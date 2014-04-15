module Glysellin
  class Shipment < ActiveRecord::Base
    self.table_name = "glysellin_shipments"

    belongs_to :order, class_name: "Glysellin::Order", autosave: true
    belongs_to :shipping_method, class_name: "Glysellin::ShippingMethod"

    after_save :process_order_shipment_state

    def vat_rate
      (1 - (eot_price / price)) * 100
    end

    def total_vat
      price - eot_price
    end

    def process_order_shipment_state
      if sent_on && order.shipment_state_name != :shipped
        order.ship!
      end
    end
  end
end
