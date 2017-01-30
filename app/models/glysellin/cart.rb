module Glysellin
  class Cart < ActiveRecord::Base
    self.table_name = 'glysellin_carts'

    include ProductsList
    include Orderer

    state_machine initial: :init do
      event :reset do
        transition any => :init
      end

      event :line_items_added do
        transition any => :filled
      end

      # When cart content is validated, including line_items list
      # and coupon codes
      #
      event :validated do
        transition any => :addresses
      end

      # When addresses are filled and validated
      #
      event :addresses_filled do
        transition any => :choose_shipping_method
      end

      # When shipping method is chosen
      #
      event :shipping_method_chosen do
        transition any => :recap
      end

      # When payment method is chosen
      #
      event :create_order do
        transition any => :ready
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

      after_transition any => :ready, do: :generate_order
    end

    belongs_to :store
    belongs_to :order, inverse_of: :cart

    has_many :line_items, as: :container, inverse_of: :container
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

    has_one :shipment, as: :shippable, dependent: :destroy,
                                       inverse_of: :shippable
    accepts_nested_attributes_for :shipment, allow_destroy: true

    has_many :discounts, as: :discountable, inverse_of: :discountable,
      dependent: :destroy
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank
    attr_accessor :discount_code

    validate :line_items_valid
    validate :discount_code_valid, if: Proc.new { |cart| discount_code.present? }

    scope :paid, -> { joins(order: :payments).where(glysellin_payments: { state: 'paid' }) }
    scope :unpaid, -> { where.not(id: unscoped.paid.select(:id)) }

    def self.fetch(options = {})
      # Only fetch unpaid carts
      cart = unpaid.where(options).first
      Glysellin.cart_expiration_checker.new(cart).call if Glysellin.cart_expiration_checker
      cart
    end

    def self.build(options = {})
      new do |cart|
        cart.state = :init
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

    def line_items_valid
      line_items.each do |line_item|
        # Line item variant is not filled
        if line_item.variant.blank?
          next add_error(:line_items, :choose_variant, item: line_item.id.to_s)
        end

        # Handle unpublished variant
        unless line_item.variant.published
          next add_error(:line_items, :not_for_sale, item: line_item.name)
        end

        # Line item has a published variant with enough stock, go ahead
        if store.available?(line_item.variant, line_item.quantity)
          next
        end

        available_quantity = store.available_quantity_for(line_item.variant)

        # Item is completely out of stock
        if available_quantity <= 0
          line_item.mark_for_destruction
          add_error(:line_items, :out_of_stock, item: line_item.name)

        # Item has stock but not enough for what was added to the cart
        else
          add_error(:line_items, :not_enough_stock, {
            item: line_item.variant.name, stock: available_quantity
          })

          line_item.quantity = available_quantity
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

    def calculate_shipment_price
      if shipment && shipment.shipping_method
        shipment.price = shipment.shipping_method.carrier(self).calculate
        shipment.eot_price = shipment.price / (1 + (Glysellin.default_vat_rate / 100))
      end
    end

    def generate_order
      # Build or clear order
      if order then order.clear else build_order end

      # One to many relationship objects and attributes can be safely reassigned
      order.customer = customer
      order.store = store
      order.use_another_address_for_shipping = use_another_address_for_shipping

      # Many to one and one to one relationship objects must be duplicated before
      # they're added to the order
      order.line_items = line_items.map(&:dup)
      order.discounts = discounts.map(&:dup)
      order.payments = payments.map(&:dup)
      # Allow nil values for one to many relationships on duplication and avoid
      # nil duplication exceptions
      order.billing_address = billing_address.try(:dup)
      order.shipping_address = shipping_address.try(:dup)
      order.shipment = shipment.try(:dup)

      order.save! && save!
    end
  end
end
