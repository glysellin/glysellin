module Glysellin
  class Shipment < ActiveRecord::Base
    self.table_name = "glysellin_shipments"

    belongs_to :order, class_name: "Glysellin::Order"
    belongs_to :shipping_method, class_name: "Glysellin::ShippingMethod"

    def vat_rate
      (1 - (eot_price / price)) * 100
    end

    def total_vat
      price - eot_price
    end
  end
end
