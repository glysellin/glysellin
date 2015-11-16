module Glysellin
  module ProductsList
    def quantified_items
      raise "You should implement `#quantified_items` in any class including Glysellin::ProductsList"
    end

    def vat_rate
      ((subtotal / eot_subtotal) - 1).round(2) * 100
    end

    def vat_ratio
      1.0 + (vat_rate / 100.0)
    end

    def vat_total
      subtotal - eot_subtotal
    end

    def vat_rates
      @vat_rates ||= Glysellin::VatRates.new(self)
    end

    def total_quantity
      line_items.map(&:quantity).reduce(&:+) || 0
    end

    # Gets order subtotal from items only
    #
    # @return [BigDecimal] the calculated subtotal
    #
    def subtotal
      line_items.map(&:total_price).reduce(&:+) || 0
    end

    def eot_subtotal
      line_items.map(&:total_eot_price).reduce(&:+) || 0
    end

    def total_weight
      line_items.map(&:total_weight).reduce(&:+) || 0
    end

    def discounts_eot_total
      discounts.map(&:eot_price).reduce(&:+) || 0
    end

    def discounts_total
      discounts.map(&:price).reduce(&:+) || 0
    end

    def discounts_total_vat
      discounts_total - discounts_eot_total
    end

    def discountable_amount
      subtotal
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

    def total_price
      subtotal + adjustments_total
    end

    def total_eot_price
      eot_subtotal + eot_adjustments_total
    end

    def total_price_before_discount
      subtotal + shipment.price
    end

    def total_eot_price_before_discount
      eot_subtotal + shipment.eot_price
    end
  end
end
