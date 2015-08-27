module Glysellin
  module Sellable
    module Stocks
      def available?(quantity = 1)
        unlimited_stocks? ? true : available_quantity > quantity
      end

      def available_quantity
        read_attribute(:available_quantity) if stores_stocks?
      end

      def unlimited_stocks?
        !stock_count
      end

      private

      def stores_stocks?
        attributes.include?(:available_quantity)
      end
    end
  end
end
