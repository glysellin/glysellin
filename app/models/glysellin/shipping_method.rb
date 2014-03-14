module Glysellin
  class ShippingMethod < ActiveRecord::Base
    include Adjustment

    self.table_name = "glysellin_shipping_methods"

    has_many :orders, inverse_of: :shipping_method
    has_many :order_adjustments, as: :adjustment

    has_many :shipments, dependent: :destroy

    scope :ordered, -> { order("name ASC") }

    private

    def adjustment_value_for order
      calculator = Glysellin.shipping_carriers[identifier]
      calculator.new(order).calculate
    end
  end
end
