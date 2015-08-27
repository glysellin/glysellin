module Glysellin
  module Sellable
    module VatRate
      def vat_rate
        read_attribute(:vat_rate) || Glysellin.default_vat_rate
      end

      def vat_ratio
        1 + vat_rate / 100
      end
    end
  end
end
