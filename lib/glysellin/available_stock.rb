module Glysellin
  class AvailableStock
    attr_reader :stock, :variant

    def initialize stock
      @stock = stock
      @variant = stock.variant
    end

    def to_i
      available_stock_count
    end

    def to_s
      to_i.to_s
    end

    def as_json
      to_i
    end

    private

    def available_stock_count
      @available_stock_count ||= stock.count + pending_orders_stock_count
    end

    def pending_orders_stock_count
      count = variant_pending_line_items.reduce(0) do |sum, line_item|
        sum + line_item.quantity
      end

      -(count)
    end

    def variant_pending_line_items
      variant.line_items.join_to_be_shipped_orders
        .where(glysellin_orders: { store_id: stock.store_id })
    end
  end
end
