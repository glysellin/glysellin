module Glysellin
  module ShippingCarrier
    class FixedPrice < Base
      register 'fixed-price', self

      def calculate
        shipping_method.price
      end
    end
  end
end
