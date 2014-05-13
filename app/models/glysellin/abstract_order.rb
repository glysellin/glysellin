module Glysellin
  class AbstractOrder < ActiveRecord::Base
    self.table_name = 'glysellin_orders'

    include ProductsList
    include Orderer

    attr_accessor :discount_code

    state_machine :state, initial: :pending do
      event :complete do
        transition all => :completed
      end

      event :cancel do
        transition all => :canceled
      end

      event :reset do
        transition all => :pending
      end

      after_transition on: :cancel do |order|
        order.shipment.cancel! if order.shipment.shipped?
      end
    end

    has_many :parcels, as: :sendable, inverse_of: :sendable
    accepts_nested_attributes_for :parcels, allow_destroy: true,
                                  reject_if: :all_blank

    has_many :line_items, through: :parcels

    # The actual buyer
    belongs_to :customer

    belongs_to :store

    has_one :shipment, as: :shippable, dependent: :destroy
    accepts_nested_attributes_for :shipment, allow_destroy: true

    has_many :discounts, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank

    validates_presence_of :billing_address, :parcels

    validates_presence_of :shipping_address,
                          if: :use_another_address_for_shipping

    before_validation :process_total_price

    after_create      :ensure_customer_addresses
    after_create      :ensure_ref

    scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }
    scope :active, -> { where.not(glysellin_orders: { state: 'canceled' }) }

    def line_items options = {}
      cached = options.fetch(:cached, true)
      cached ? parcels.map(&:line_items).flatten : super()
    end

    # Ensures there is always an order reference
    #
    def ensure_ref
      unless ref
        update_column(:ref, Glysellin.order_reference_generator.call(self))
      end
    end

    def process_total_price
      write_attribute(:total_price, total_price)
      write_attribute(:total_eot_price, total_eot_price)
    end

    # Ensures that the customer has a billing and, if needed shipping, address.
    #
    def ensure_customer_addresses
      if customer && !customer.billing_address
        customer.create_billing_address(billing_address.clone_attributes)

        customer.use_another_address_for_shipping =
          use_another_address_for_shipping

        if use_another_address_for_shipping
          customer.create_shipping_address(shipping_address.clone_attributes)
        end
      end
    end

    # Customer's e-mail directly accessible from the order
    #
    # @return [String] the wanted e-mail string
    def email
      customer && customer.email
    end

    def name
      customer && customer.full_name ||
        billing_address && billing_address.full_name
    end
  end
end
