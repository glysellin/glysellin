module Glysellin
  module ShippingCarrier
    class Colissimo < Base
      include Helpers::CountryWeightTable

      register 'colissimo', self

      country_weight_table_file 'colissimo.csv'

      def initialize order
        @order = order
      end

      def trackable?
        true
      end

      def tracking_url
        return unless @order.shipment.tracking_code.present?
        "http://www.colissimo.fr/portail_colissimo/suivre.do?colispart=#{ @order.shipment.tracking_code }"
      end

      def calculate
        price_for_weight_and_country
      end
    end
  end
end