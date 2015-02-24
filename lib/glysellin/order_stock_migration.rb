module Glysellin
  class OrderStockMigration
    attr_reader :order

    def initialize order
      @order = order
    end

    def apply
      migrable_items.each(&:decrement!)
    end

    def rollback
      migrable_items.each(&:increment!)
    end

    private

    def migrable_items
      @migrable_items ||= line_items.map do |line_item|
        OrderStockMigrationLine.new(line_item, order.store)
      end
    end

    def line_items
      @line_items ||= order.line_items(true).includes(
        variant: { stocks: :store }
      )
    end
  end

  class OrderStockMigrationLine
    attr_reader :line_item, :store

    def initialize line_item, store
      @line_item = line_item
      @store = store
    end

    def increment!
      stock.save! if stock.new_record?
      stock.increment!(:count, line_item.quantity)
    end

    def decrement!
      stock.save! if stock.new_record?
      stock.decrement!(:count, line_item.quantity)
    end

    private

    def stock
      @stock ||= line_item.variant.stocks_for_all_stores[store]
    end
  end
end
