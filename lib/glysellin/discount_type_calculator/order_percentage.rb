module Glysellin
  module DiscountTypeCalculator
    class OrderPercentage < Glysellin::DiscountTypeCalculator::Base
      register 'order-percentage', self

      attr_accessor :discountable_amount, :value

      def initialize discountable_amount, value
        @discountable_amount = discountable_amount
        @value = (value.to_f / 100.0) # Convert to percentage
      end

      def calculate
        -(discountable_amount * value)
      end
    end
  end
end
