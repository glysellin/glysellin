module Glysellin
  class Order < ActiveRecord::Base
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

    has_many :parcels, as: :sendable
    accepts_nested_attributes_for :parcels, allow_destroy: true,
                                  reject_if: :all_blank

    has_many :line_items, through: :parcels

    # The actual buyer
    belongs_to :customer

    belongs_to :store

    has_one :cart

    has_one :invoice, dependent: :nullify

    # Payment tries
    has_many :payments,
             -> { extending Glysellin::Payments::AggregationMethods },
             as: :payable, inverse_of: :payable, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    delegate :balanced?, to: :payments, prefix: true

    has_one :shipment, as: :shippable, dependent: :destroy
    accepts_nested_attributes_for :shipment, allow_destroy: true

    has_many :order_adjustments, inverse_of: :order, dependent: :destroy
    accepts_nested_attributes_for :order_adjustments

    has_many :discounts, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank

    validates_presence_of :billing_address, :parcels

    validates_presence_of :shipping_address,
                          if: :use_another_address_for_shipping

    before_validation :process_total_price
    before_validation :process_payments

    after_create      :ensure_customer_addresses
    after_create      :ensure_ref

    scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }

    scope :to_be_shipped, -> {
      active
        .joins(
          'INNER JOIN glysellin_shipments ' +
          'ON glysellin_shipments.shippable_id = glysellin_orders.id'
        )
        .where(
          glysellin_shipments: {
            shippable_type: 'Glysellin::Order', state: "pending"
          }
        )
    }

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

    def process_payments
      payments_manager.save
    end

    def payments_manager
      @payments_manager ||= Glysellin::Payments::Manager.new(self)
    end

    def execute_sold_callbacks
      line_items.each do |line_item|
        # If line item's associated variant still exists
        if (sellable = line_item.sellable) && (callback = sellable.sold_callback)
          case callback.class.to_s
          when "Proc" then sellable.instance_exec(self, &callback)
          else sellable.send(callback, self)
          end
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

    ########################################
    #
    #               Products
    #
    ########################################

    def line_items=(attributes)
      line_items = attributes.reduce([]) do |list, line_item|
        item = LineItem.build_from_line_item(line_item[:id], line_item[:quantity])
        item ? (list << item) : list
      end

      super(line_items)
    end

    ########################################
    #
    #               Payment
    #
    ########################################

    # Gives the last payment found for that order
    #
    # @return [Payment, nil] the found Payment item or nil
    #
    def payment
      payments.last
    end

    # Returns the last payment method used if there has already been
    #   a payment try
    #
    # @return [PaymentType, nil] the PaymentMethod or nil
    #
    def payment_method
      payment.type rescue nil
    end

    def payment_method_id=(type_id)
      payment = self.payments.build
      payment.type = PaymentMethod.find(type_id)
    end

    ########################################
    #
    #              Adresses
    #
    ########################################

    # Set customer from a Hash of attributes
    #
    def customer=(attributes)
      unless attributes && (self.customer_id = attributes[:id])
        user = self.build_customer(attributes)

        if Glysellin.allow_anonymous_orders &&
          !(user.password || user.password_confirmation)

          password = (rand*(10**20)).to_i.to_s(36)
          user.password = password
          user.password_confirmation = password
        end
      end
    end
  end
end
