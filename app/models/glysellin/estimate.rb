module Glysellin
  class Estimate < AbstractOrder
    belongs_to :order

    after_save :set_prices_cache_columns

    state_machine :state, initial: :draft do
      event :send_to_customer do
        transition all => :sent
      end

      event :accept do
        transition all => :accepted
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

    def generate_order!
      build_order unless order

      parcel = (order.parcels.first || order.parcels.build(name: 'Carton 1'))
      parcel.line_items = line_items.map(&:dup)

      order.customer = customer
      order.use_another_address_for_shipping = use_another_address_for_shipping
      order.billing_address = billing_address.try(:dup)
      order.shipping_address = shipping_address.try(:dup)
      order.shipment = shipment.try(:dup)

      self.order = order
      save!
    end

    def self.export(format = :xls)
      ExportEstimate.new(format, all).file_path
    end
  end
end