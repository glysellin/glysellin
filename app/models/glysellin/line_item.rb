module Glysellin
  class LineItem < ActiveRecord::Base
    self.table_name = 'glysellin_line_items'

    belongs_to :variant
    belongs_to :container, polymorphic: true

    has_one :discount, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discount, allow_destroy: true,
      reject_if: :all_blank

    scope :join_orders, -> {
      joins(
        'INNER JOIN glysellin_parcels ' +
          'ON glysellin_parcels.id = glysellin_line_items.container_id ' +
        'INNER JOIN glysellin_orders ' +
          'ON glysellin_orders.id = glysellin_parcels.sendable_id'
      ).where(
        glysellin_line_items: { container_type: 'Glysellin::Parcel' },
        glysellin_parcels: { sendable_type: 'Glysellin::Order'}
      )
    }

    def autofill_from variant
      %w(sku name eot_price vat_rate price weight).each do |key|
        self.public_send(:"#{ key }=", variant.public_send(key))
      end
    end

    def eot_subtotal
      quantity * eot_price
    end

    def total_eot_price
      eot_subtotal + discount_price
    end

    def total_price
      total_eot_price + total_vat
    end

    def total_vat
      total_eot_price * (vat_rate / 100.0)
    end

    def discountable_amount
      eot_subtotal
    end

    def discount_price
      @discount_price ||= (discount && discount.price) || 0
    end

    def total_weight
      quantity * weight
    end

    def sellable
      variant && variant.sellable
    end

    def weight
      super.presence || Glysellin.default_product_weight
    end
  end
end
