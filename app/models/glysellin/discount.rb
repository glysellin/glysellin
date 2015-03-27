module Glysellin
  class Discount < ActiveRecord::Base
    self.table_name = "glysellin_discounts"

    belongs_to :discountable, polymorphic: true
    belongs_to :discount_type

    validates_presence_of :value, :discount_type_id

    def eot_price
      @eot_price ||= price - (price * discountable.vat_rate)
    end

    def price
      @price ||= calculator.calculate
    end

    def discountable_amount
      @discountable_amount ||= discountable.discountable_amount
    end

    def discountable_amount=(amount)
      @discountable_amount = amount

      # Force refreshing dynamic values
      @eot_price = @price = @eot_discountable_amount = nil
    end

    def eot_discountable_amount
      @eot_discountable_amount ||= discountable_amount - (discountable_amount * discountable.vat_rate)
    end

    def self.build_from(discount_code)
      new.tap do |discount|
        discount.discount_type = discount_code.discount_type
        discount.value = discount_code.value
        discount.name = discount_code.name
      end
    end

    private

    def calculator
      @calculator ||= Glysellin.discount_type_calculators[
        discount_type.identifier
      ].new(discountable_amount, value)
    end
  end
end
