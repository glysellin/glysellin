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
        transition all => :choose_payment_method
      end

      # When payment method is chosen
      #
      event :payment_method_chosen do
        transition all => :ready
      end

      # State validations
      state :line_items_added, :addresses, :choose_shipping_method, :choose_payment_method, :ready do
        validates_presence_of :line_items
      end

      state :choose_shipping_method, :choose_payment_method, :ready do
        validates :customer, :billing_address, presence: true
        validates :shipping_address, presence: true, if: :use_another_address_for_shipping
      end

      state :choose_payment_method, :ready do
        validates :shipment, presence: true
      end

      state :ready do
        validates :payments, presence: true
      end

      before_transition any => :ready, do: :generate_order!

      before_transition do |cart, transition|
        from, to = transition.from_name, transition.to_name

        if from != to && from == :ready
          cart.cancel_order!
        end
      end
    end

    belongs_to :store

    belongs_to :order

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

    has_many :discounts, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank

    validate :line_items_variants_published
    validate :line_items_in_stock
    validate :line_items_stocks_available

    def self.fetch_or_initialize options
      where(id: options[:id]).first_or_initialize do |cart|
        cart.store = options[:store]
      end
    end

    def empty?
      line_items.length == 0
    end

    def available_states
      %w(filled addresses choose_shipping_method choose_payment_method ready)
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

    def remove_line_item id
      line_items.destroy(line_item(id))
      reset! if empty?
    end

    def line_item id
      line_items.find { |item| item.id == id.to_i }
    end

    def line_items_variants_published
      line_items.each do |line_item|
        unless line_item.variant.published
          line_item.mark_for_destruction!
          add_error(:line_items, :not_for_sale, item: line_item.name)
        end
      end
    end

    def line_items_in_stock
      line_items.each do |line_item|
        unless store.in_stock?(line_item.variant)
          line_item.mark_for_destruction!
          add_error(:line_items, :out_of_stock, item: line_item.name)
        end
      end
    end

    def line_items_stocks_available
      line_items.each do |line_item|
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

    def generate_order!
      build_order unless order

      parcel = (order.parcels.first || order.parcels.build(name: 'Default'))
      parcel.line_items = line_items

      order.customer = customer
      order.use_another_address_for_shipping = use_another_address_for_shipping
      order.billing_address = billing_address
      order.shipping_address = shipping_address

      order.shipment = shipment
      order.payments = payments

      billing_address(true)
      shipping_address(true)
      shipment(true)
    end

    def cancel_order!
      self.line_items = order.parcels.first.line_items

      self.billing_address = order.billing_address
      self.shipping_address = order.shipping_address

      self.shipment = order.shipment
      self.payments = order.payments

      order.billing_address(true)
      order.shipping_address(true)
      order.shipment(true)
      order.payments(true)

      order.destroy
    end
  end
end