module Glysellin
  module ShippingCarrier
    class FreeShipping < Base
      register 'free-shipping', self

      def calculate
        0
      end
    end
  end
end
