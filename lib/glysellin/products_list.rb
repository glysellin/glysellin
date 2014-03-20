module Glysellin
  module ProductsList
    extend ActiveSupport::Concern

    def quantified_items
      raise "You should implement `#quantified_items` in any class including Glysellin::ProductsList"
    end

    def each_items &block
      if block_given?
        quantified_items.each(&block)
      else
        quantified_items.each
      end
    end

    def vat_rate
      1 - (eot_subtotal / subtotal)
    end

    def vat_total
      subtotal - eot_subtotal
    end

    # Gets order subtotal from items only
    #
    # @return [BigDecimal] the calculated subtotal
    #
    def subtotal
      each_items.reduce(0) do |total, (item, quantity)|
        total + (item.price * quantity)
      end
    end

    def eot_subtotal
      each_items.reduce(0) do |total, (item, quantity)|
        total + (item.eot_price * quantity)
      end
    end

    def total_weight
      each_items.reduce(0) do |total, (item, quantity)|
        weight = item.weight.presence || Glysellin.default_product_weight
        total + (quantity * weight)
      end
    end

    def adjustments
      adjustments  = shipment ? [shipment] : []
      adjustments += discounts.to_a
    end

    def adjustments_total
      adjustments.map(&:price).reduce(&:+) || 0
    end

    def eot_adjustments_total
      adjustments.map(&:eot_price).reduce(&:+) || 0
    end

    # Gets order total price from subtotal and adjustments
    #
    # @param [Boolean] df Defines if we want to get duty free price or not
    #
    # @return [BigDecimal] the calculated total price
    def total_price
      (subtotal + adjustments_total).round(2)
    end

    def total_eot_price
      (eot_subtotal + eot_adjustments_total).round(2)
    end
  end
end
