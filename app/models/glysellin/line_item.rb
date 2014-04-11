module Glysellin
  class LineItem < ActiveRecord::Base
    self.table_name = "glysellin_line_items"

    belongs_to :variant
    belongs_to :parcel

    has_one :discount, as: :discountable
    accepts_nested_attributes_for :discount, allow_destroy: true,
      reject_if: :all_blank

    # The attributes we getch from a product to build our order item
    PRODUCT_ATTRIBUTES_FOR_ITEM = %w(sku name eot_price vat_rate price weight)

    delegate :order, to: :parcel

    class << self
      # Create an item from product or bundle id
      #
      # @param [String] id The id string of the item
      # @param [Boolean] bundle If it's a bundle or just one product
      #
      # @return [LineItem] The created order item
      #
      def build_from_product id, quantity
        variant = Glysellin::Variant.find_by_id(id)

        attrs = PRODUCT_ATTRIBUTES_FOR_ITEM.map do |key|
          [key, variant.public_send(key)]
        end

        self.new Hash[attrs].merge(
          "quantity" => quantity,
          "variant_id" => variant.id
        )
      end
    end

    def total_eot_price
      quantity * eot_price
    end

    def total_price
      total_eot_price + total_vat
    end

    def total_vat
      total_eot_price * (vat_rate / 100.0)
    end

    def sellable
      variant && variant.sellable
    end
  end
end
