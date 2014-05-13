module Glysellin
  class Order < AbstractOrder
    has_one :cart
    has_one :invoice, dependent: :nullify

    # Payment tries
    has_many :payments,
             -> { extending Glysellin::Payments::AggregationMethods },
             as: :payable, inverse_of: :payable, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    delegate :balanced?, to: :payments, prefix: true

    before_validation :process_payments

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

    def process_payments
      payments_manager.save
    end

    def payments_manager
      @payments_manager ||= Glysellin::Payments::Manager.new(self)
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
  end
end
