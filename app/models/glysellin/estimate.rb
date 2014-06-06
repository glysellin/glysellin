module Glysellin
  class Estimate < AbstractOrder
    belongs_to :order

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

    def generate_order!
      build_order unless order

      parcel = (order.parcels.first || order.parcels.build(name: 'Carton 1'))
      parcel.line_items = line_items.map(&:dup)

      order.customer = customer
      order.use_another_address_for_shipping = use_another_address_for_shipping
      order.billing_address = billing_address.dup
      order.shipping_address = shipping_address.dup

      order.shipment = shipment.dup

      self.order = order
      save!
    end
  end
end