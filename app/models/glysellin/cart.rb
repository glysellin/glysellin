module Glysellin
  class Cart < ActiveRecord::Base
    self.table_name = 'glysellin_carts'

    include ProductsList
    include Orderer

    state_machine initial: :init do
      event :reset do
        transition all => :init
      end

      event :line_items_added do
        transition all => :filled
      end

      # When cart content is validated, including line_items list
      # and coupon codes
      #
      event :validated do
        transition all => :addresses
      end

      # When addresses are filled and validated
      #
      event :addresses_filled do
        transition all => :choose_shipping_method
      end

      # When shipping method is chosen
      #
      event :shipping_method_chosen do
        transition all => :recap
      end

      # When payment method is chosen
      #
      event :create_order do
        transition all => :ready
      end

      # State validations
      state :line_items_added, :addresses, :choose_shipping_method, :recap, :ready do
        validates :line_items, presence: true
      end

      state :choose_shipping_method, :recap, :ready do
        validates :customer, :billing_address, presence: true
        validates :shipping_address, presence: true, if: :use_another_address_for_shipping
      end

      state :recap, :ready do
        validates :shipment, presence: true
      end

      state :ready do
        validates :payments, presence: true
      end

      after_transition any => :ready, do: :generate_order!

      before_transition do |cart, transition|
        from, to = transition.from_name, transition.to_name

        if from != to && from == :ready
          if cart.order.present?
            cart.cancel_order!
          end
        end
      end
    end

    belongs_to :store
    belongs_to :order, autosave: true

    has_many :line_items, as: :container
    accepts_nested_attributes_for :line_items, allow_destroy: true,
      reject_if: :all_blank

    # The actual buyer
    belongs_to :customer, class_name: 'Glysellin::Customer'
    accepts_nested_attributes_for :customer, reject_if: :all_blank,
      allow_destroy: true

    # Payment tries
    has_many :payments,
             -> { extending Glysellin::Payments::AggregationMethods },
             as: :payable, inverse_of: :payable, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    has_one :shipment, as: :shippable, dependent: :destroy
    accepts_nested_attributes_for :shipment, allow_destroy: true

    has_many :discounts, as: :discountable, inverse_of: :discountable,
      dependent: :destroy
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank
    attr_accessor :discount_code

    validate :line_items_variants_presence
    validate :line_items_variants_published
    validate :line_items_in_stock
    validate :line_items_stocks_available
    validate :discount_code_valid, if: Proc.new { |cart| discount_code.present? }

    def self.fetch_or_initialize options
      where(id: options[:id]).first_or_create! do |cart|
        cart.store = options[:store]
      end
    end

    def empty?
      line_items.length == 0
    end

    def available_states
      %w(filled addresses choose_shipping_method recap ready)
    end

    def available_events
      %w(
        line_items_added validated addresses_filled shipping_method_chosen
        payment_method_chosen
      )
    end

    def state_index
      available_states.index(state) || -1
    end

    def remove_line_item(id)
      line_items.destroy(line_item(id))
      reset! if empty?
    end

    def line_item(id)
      line_items.find { |item| item.id == id.to_i }
    end

    def line_items_variants_presence
      line_items.each do |line_item|
        if line_item.variant.blank?
          add_error(:line_items, :choose_variant, item: line_item.id.to_s)
        end
      end
    end

    def line_items_variants_published
      line_items.each do |line_item|
        next unless line_item.variant.present?
        unless line_item.variant.published
          line_item.mark_for_destruction!
          add_error(:line_items, :not_for_sale, item: line_item.name)
        end
      end
    end

    def line_items_in_stock
      line_items.each do |line_item|
        next unless line_item.variant.present?
        unless store.in_stock?(line_item.variant)
          line_item.mark_for_destruction!
          add_error(:line_items, :out_of_stock, item: line_item.name)
        end
      end
    end

    def line_items_stocks_available
      line_items.each do |line_item|
        next unless line_item.variant.present?
        unless store.available?(line_item.variant, line_item.quantity)
          available = store.available_quantity_for(line_item.variant)

          add_error(
            :line_items, :not_enough_stock,
            item: line_item.variant.name, stock: available
          )

          line_item.quantity = available
        end
      end
    end

    def add_error(key, error_key, options = {})
      errors.add(key, I18n.t("glysellin.errors.cart.#{ error_key }", options))
    end

    def add_discount_code!(discount_code)
      self.discount_code = discount_code
      save
    end

    def discount_code_valid
      if (code = DiscountCode.from_code(discount_code).first).present?
        if code.applicable_for?(total_price)
          discount = Discount.build_from(code)
          self.discounts = [discount]
        else
          errors.add(
            :discount_code,
            I18n.t('glysellin.errors.discount_code.not_applicable')
          )
        end
      else
        errors.add(:discount_code, :invalid)
      end
    end

    def generate_order!
      build_order unless order

      order.line_items = line_items

      order.customer = customer
      order.use_another_address_for_shipping = use_another_address_for_shipping
      order.billing_address = billing_address
      order.shipping_address = shipping_address

      order.shipment = shipment
      order.payments = payments

      line_items(true)
      billing_address(true)
      shipping_address(true)
      shipment(true)
      payments(true)
    end

    def cancel_order!
      self.line_items = order.line_items

      self.billing_address = order.billing_address
      self.shipping_address = order.shipping_address

      self.shipment = order.shipment
      self.payments = order.payments

      order.line_items(true)
      order.billing_address(true)
      order.shipping_address(true)
      order.shipment(true)
      order.payments(true)

      order.destroy
    end
  end
end
