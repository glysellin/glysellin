require 'state_machine'

module Glysellin
  class Order < ActiveRecord::Base
    include ProductsList
    include Orderer

    self.table_name = 'glysellin_orders'

    attr_accessor :discount_code

    state_machine initial: :ready do

      event :paid do
        transition any => :paid
      end

      event :shipped do
        transition paid: :shipped
      end

      after_transition on: :paid, do: :set_payment
      after_transition on: :paid, do: :execute_sold_callbacks
    end

    # Relations
    #
    # Order products are used to map order to cloned and simplified products
    #   so the Order propererties can't be affected by product updates
    has_many :products, class_name: 'Glysellin::LineItem',
      foreign_key: 'order_id', dependent: :destroy

    # The actual buyer
    belongs_to :customer, class_name: "::#{ Glysellin.user_class_name }",
      foreign_key: 'customer_id', :autosave => true

    # Payment tries
    has_many :payments, inverse_of: :order, dependent: :destroy

    belongs_to :shipping_method, inverse_of: :orders

    has_many :order_adjustments, inverse_of: :order, dependent: :destroy

    # We want to be able to see fields_for addresses
    accepts_nested_attributes_for :products
    # accepts_nested_attributes_for :customer
    accepts_nested_attributes_for :payments
    accepts_nested_attributes_for :order_adjustments

    attr_accessible :payments, :products, :products_ids,
      :customer, :customer_id, :ref, :user, :payments,
      :payments_attributes, :products_attributes, :paid_on,
      :state, :payment_method_id, :billing_address, :shipping_address,
      :shipping_method_id, :discount_code, :order_adjustments_attributes

    validates_presence_of :customer, :billing_address, :shipping_address,
      :products

    before_validation :process_adjustments
    after_save :ensure_ref
    after_create :ensure_customer_addresses
    before_save :set_paid_if_paid_by_check
    before_save :notify_shipped

    scope :from_customer, lambda { |customer_id| where(customer_id: customer_id) }

    def quantified_items
      products.map { |product| [product, product.quantity] }
    end

    # Ensures there is always an order reference
    #
    def ensure_ref
      update_attribute(:ref, self.generate_ref) unless self.ref
    end

    # Ensures that the customer has a billing and, if needed shipping, address.
    #
    def ensure_customer_addresses
      unless customer.billing_address
        customer.create_billing_address(billing_address.clone_attributes)

        unless billing_address.same_as?(shipping_address)
          customer.create_shipping_address(shipping_address.clone_attributes)
        end
      end
    end

    # If admin sets payment date by hand and order was paid by check,
    # fire :paid event
    #
    def set_paid_if_paid_by_check
      paid! if (paid_on_changed? and ready? and paid_by_check?)
    end

    def paid_by_check?
      payment and payment.by_check?
    end

    def set_shipping_price
      build_adjustment_from shipping_method if shipping_method
    end

    # Callback invoked after event :paid
    def set_payment
      self.payment.new_status Payment::PAYMENT_STATUS_PAID
      update_attribute(:paid_on, payment.last_payment_action_on)
    end

    def execute_sold_callbacks
      products.each do |product|
        # If line item's associated variant still exists
        if (sellable = product.sellable) && (callback = sellable.sold_callback)
          case callback.class.to_s
          when "Proc" then sellable.instance_exec(self, &callback)
          else sellable.send(callback, self)
          end
        end
      end
    end

    # Callback invoked after event :shipped
    def notify_shipped
      if state_changed? && shipped?
        OrderCustomerMailer.send_order_shipped_email(self).deliver
      end
    end

    # Define model to use it's ref when asked for parameterized
    #   representation of itself
    #
    # @return [String] the order ref
    def to_param
      ref
    end

    # Automatic ref generation for an order that can be overriden
    #   within the config initializer, and only executes if there's no
    #   existing ref inside for this order
    #
    # @return [String] the generated or existing ref
    def generate_ref
      if ref
        ref
      else
        if Glysellin.order_reference_generator
          Glysellin.order_reference_generator.call(self)
        else
          "#{Time.now.strftime('%Y%m%d%H%M')}-#{id}"
        end
      end
    end

    # Customer's e-mail directly accessible from the order
    #
    # @return [String] the wanted e-mail string
    def email
      customer && customer.email
    end

    ########################################
    #
    #               Products
    #
    ########################################

    def products=(attributes)
      products = attributes.reduce([]) do |list, product|
        item = LineItem.build_from_product(product[:id], product[:quantity])
        item ? (list << item) : list
      end

      super(products)
    end

    ########################################
    #
    #               Adjustments
    #
    ########################################

    def build_adjustment_from item
      # Handle replacing duplicate adjustments on the same order
      existing_adjustments = order_adjustments.where(
        adjustment_type: item.class.to_s
      )
      # Destroy exisiting ones
      existing_adjustments.each(&:destroy) if existing_adjustments.length > 0
      # Build new adjustment from existing discount code
      order_adjustments.build(item.to_adjustment(self))
    end

    def process_adjustments
      build_adjustment_from(shipping_method) if shipping_method

      if discount_code
        code = Glysellin::DiscountCode.from_code(discount_code)
        build_adjustment_from(code) if code
      end
    end

    ########################################
    #
    #               Payment
    #
    ########################################

    # Gives the last payment found for that order
    #
    # @return [Payment, nil] the found Payment item or nil
    def payment
      payments.last
    end

    # Returns the last payment method used if there has already been
    #   a payment try
    #
    # @return [PaymentType, nil] the PaymentMethod or nil
    def payment_method
      payment.type rescue nil
    end

    def payment_method_id=(type_id)
      payment = self.payments.build :status => Payment::PAYMENT_STATUS_PENDING
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
      unless (self.customer_id = attributes[:id])
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
