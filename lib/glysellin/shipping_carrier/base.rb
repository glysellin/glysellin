module Glysellin
  def self.shipping_carriers
    Hash[ShippingCarrier.shipping_carriers_list.map { |sc| [sc[:name], sc[:carrier]] }]
  end

  def shipping_carrier(&block)
    if block_given?
      ShippingCarrier.config &block
    else
      ShippingCarrier
    end
  end

  module ShippingCarrier
    extend AbstractController::Rendering

    # List of available gateways in the app
    mattr_accessor :shipping_carriers_list
    @@shipping_carriers_list = []

    class Base
      attr_reader :order, :shipping_method

      def initialize(order, shipping_method)
        @order = order
        @shipping_method = shipping_method
      end

      def trackable?
        false
      end

      def self.register name, carrier
        ShippingCarrier.shipping_carriers_list << { :name => name, :carrier => carrier }
      end

      def self.config(&block)
        block ? block.call(self) : self
      end
    end
  end
end
