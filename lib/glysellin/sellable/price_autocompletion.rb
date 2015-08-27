module Glysellin
  module Sellable
    module PriceAutocompletion
      extend ActiveSupport::Concern

      included do
        before_validation :check_prices
      end

      protected

      def check_prices
        return unless price.present? || eot_price.present?
        # If we have to fill one of the prices when changed
        if eot_changed_alone?
          self.price = (eot_price * vat_ratio).round(2)
        elsif price_changed_alone?
          self.eot_price = (price / vat_ratio).round(2)
        end
      end

      def eot_changed_alone?
        eot_changed_alone = eot_price_changed? && !price_changed?
        new_record_eot_alone = new_record? && eot_price && !price

        eot_changed_alone || new_record_eot_alone
      end

      def price_changed_alone?
        price_changed? || (new_record? && price)
      end
    end
  end
end
