module Glysellin
  module ProductsList
    def quantified_items
      raise "You should implement `#quantified_items` in any class including Glysellin::ProductsList"
    end

    def vat_rate
      1 - (eot_subtotal / subtotal)
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
      processed_discounts.map(&:eot_price).reduce(&:+) || 0
    end

    def discounts_total
      processed_discounts.map(&:price).reduce(&:+) || 0
    end

    def discounts_total_vat
      discounts_total - discounts_eot_total
    end

    def discountable_amount
      subtotal
    end

    def adjustments
      adjustments  = shipment ? [shipment] : []
      adjustments += processed_discounts.to_a
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

    def processed_discounts
      discountable_amount = self.discountable_amount

      discounts.map do |discount|
        discount.discountable_amount = discountable_amount
        discountable_amount += discount.price
        discount
      end
    end
  end
end
