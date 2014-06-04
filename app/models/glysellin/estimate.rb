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
  end
end