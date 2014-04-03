module Glysellin
  class Discount < ActiveRecord::Base
    self.table_name = "glysellin_discounts"

    belongs_to :discountable, polymorphic: true, autosave: true
    belongs_to :discount_type

    validates_presence_of :value, :discount_type_id

    def eot_price
      price - (price * discountable.vat_rate)
    end

    def price
      calculator.calculate
    end

    private

    def calculator
      @calculator ||= Glysellin.discount_type_calculators[
        discount_type.identifier
      ].new(discountable, value)
    end
  end
end
