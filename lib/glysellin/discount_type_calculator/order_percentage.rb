module Glysellin
  module DiscountTypeCalculator
    class OrderPercentage < Glysellin::DiscountTypeCalculator::Base
      register 'order-percentage', self

      attr_accessor :discountable, :value

      def initialize(discountable, value)
        @discountable = discountable
        @value = (value.to_f / 100.0) # Convert to percentage
      end

      def calculate
        (-(discountable.discountable_amount * value)).round(2)
      end
    end
  end
end
