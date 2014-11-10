module Glysellin
  class Order < AbstractOrder
    has_one :cart
    has_one :invoice, dependent: :destroy

    has_many :payments, -> {
      extending Glysellin::Payments::AggregationMethods
    }, as: :payable, inverse_of: :payable, dependent: :destroy
    accepts_nested_attributes_for :payments, allow_destroy: true

    belongs_to :customer, class_name: 'Glysellin::Customer'
    belongs_to :store_client, class_name: 'Glysellin::StoreClient'
    delegate :balanced?, to: :payments, prefix: true

    after_save :set_prices_cache_columns

    before_validation :process_payments

    scope :to_be_shipped, -> {
      active.joins(:shipment).where(glysellin_shipments: { state: :pending })
    }

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
      update_column :total_price_cache, total_price.to_s.gsub('.', ',')
      update_column :total_eot_price_cache, total_eot_price.to_s.gsub('.', ',')
    end

    def group_line_items_and_sum_quantities!
      parcels.each do |parcel|
        sums = parcel.line_items.group(:sku).count.to_a

        sums.each do |(key, sum)|
          records = parcel.line_items.where(sku: key).all
          next if records.size == 1

          records[0].update! quantity: sum
          records[1..-1].each &:destroy
        end
      end
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
