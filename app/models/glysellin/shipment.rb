module Glysellin
  class Shipment < ActiveRecord::Base
    self.table_name = "glysellin_shipments"

    belongs_to :order, class_name: "Glysellin::Order"
    belongs_to :shipping_method, class_name: "Glysellin::ShippingMethod"
  end
end