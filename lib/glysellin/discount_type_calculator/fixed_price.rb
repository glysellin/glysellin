module Glysellin
  module DiscountTypeCalculator
    class FixedPrice < Glysellin::DiscountTypeCalculator::Base
      register 'fixed-price', self

      attr_reader :value

      def initialize(_, value)
        @value = value
      end

      def calculate
        (-value).round(2)
      end
    end
  end
end
