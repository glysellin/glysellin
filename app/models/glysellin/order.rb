module Glysellin
  class Order < AbstractOrder

    scope :to_be_shipped, -> { active.search(shipment_state_eq: :pending).result }

    before_validation :process_payments

    has_one :cart
    has_one :invoice, dependent: :destroy

    has_many :payments, -> {
      extending Glysellin::Payments::AggregationMethods
    }, as: :payable, inverse_of: :payable, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    belongs_to :customer, class_name: 'Glysellin::Customer'
    delegate :balanced?, to: :payments, prefix: true

    after_save :set_prices_cache_columns

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

    def set_prices_cache_columns
      # (!) is ugly but we should have errors here at all, nil.to_s return ''
      update_column :total_price_cache, total_price.to_s.gsub('.', ',')
      update_column :total_eot_price_cache, total_eot_price.to_s.gsub('.', ',')
    end

    def process_payments
      payments_manager.save
    end

    def payments_manager
      @payments_manager ||= Glysellin::Payments::Manager.new(self)
    end

    def payment
      payments.last
    end

    def payment_method
      payment.type rescue nil
    end

    def self.export(format = :xls)
      ExportOrder.new(format, all).file_path
    end
  end
end
