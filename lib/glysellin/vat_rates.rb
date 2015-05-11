module Glysellin
  class VatRates < Hash
    attr_accessor :order

    def initialize order
      @order = order
      refresh
    end

    def refresh
      @order_total_eot_price = order.total_eot_price
      @order_eot_subtotal = order.eot_subtotal
      @order_discounts_total_vat = order.discounts_total_vat

      process_items_rates!
      process_shipment_rates!

      self
    end

    private

    def process_items_rates!
      order.line_items.each do |item|
        add(item.vat_rate, item_total_vat(item))
      end
    end

    def process_shipment_rates!
      if order.shipment && order.shipment.price != 0
        add(order.shipment.vat_rate, order.shipment.total_vat)
      end
    end

    def add(rate, value)
      rate = rate.round(2)
      self[rate] ||= 0
      self[rate] += value
    end

    def item_total_vat item
      # share of the order total price before discounts are applied
      weight = @order_total_eot_price / @order_eot_subtotal
      # total vat price deducing its share of the discounts vat
      item.total_vat + (weight * @order_discounts_total_vat)
    end
  end
end
