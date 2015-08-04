module Glysellin
  module ShippingCarrier
    class FlatRate < Base
      register 'flat-rate', self

      @@config_file = nil

      def initialize(order, shipping_method)
        super

        raise "Config file is not defined for #{ self.name } shipping method" unless @@config_file
        @config = YAML.load(File.read @@config_file)['config']
      end

      def rate(order)
        @config.each do |item|
          if item['countries'].split(',').include?(order.shipping_address.country)
            return process_rate(order, item['rates'])
          end
        end

        # Return nil if country not accepted
        nil
      end

      def process_rate(order, rates)
      end

      def price_for_order order
        total_items = order.products.reduce(0) do |total, item|
          total + item.quantity
        end

        price_for_items_quantity(total_items)
      end

      def price_for_items_quantity quantity

      end
    end
  end
end
