module Glysellin
  module Cart
    module Adjustment
      mattr_accessor :types
      @@types = {}

      def self.build cart, attributes
        type = attributes[:type]
        Glysellin::Cart::Adjustment.types[type].new(cart, attributes)
      end
    end
  end
end

require 'glysellin/cart_steps/adjustment/base'
require 'glysellin/cart_steps/adjustment/discount_code'
require 'glysellin/cart_steps/adjustment/shipping_method'