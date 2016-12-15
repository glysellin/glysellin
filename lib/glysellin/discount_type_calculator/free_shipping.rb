module Glysellin
  module DiscountTypeCalculator
    class FreeShipping < Glysellin::DiscountTypeCalculator::Base
      register 'free-shipping', self

      attr_accessor :discountable, :value

      def initialize(discountable, value)
        @discountable = discountable
        @value = (value.to_f / 100.0) # Convert to percentage
      end

      def calculate
        -(discountable.try(:shipment).try(:price) || 0)
      end
    end
  end
end
