module Glysellin
  class LineItem < ActiveRecord::Base
    self.table_name = 'glysellin_line_items'

    belongs_to :variant
    belongs_to :container, polymorphic: true

    has_one :discount, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discount, allow_destroy: true,
      reject_if: :all_blank

    validates :vat_rate, :eot_price, :price, :quantity, presence: true

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

    def autofill_from(variant)
      self.variant_id = variant.id

      %w(sku name eot_price price vat_rate weight).each do |key|
        self.public_send(:"#{ key }=", variant.public_send(key))
      end
    end

    def price
      (eot_price * (1 + vat_rate_division)).round
    end

    def vat_rate_division
      (vat_rate / 100.0)
    end

    def eot_subtotal
      eot_price * quantity
    end

    def subtotal
      price * quantity
    end

    def total_eot_price
      (eot_subtotal + discount_price).round 2
    end

    def total_price
      (subtotal + discount_price).round 2
    end

    def total_vat
      total_eot_price * vat_rate_division
    end

    def discountable_amount
      eot_subtotal
    end

    def discount_eot_price
      @discount_eot_price ||= (discount && discount.price) || 0
    end

    def discount_price
      (discount_eot_price * (1 + vat_rate_division)).round 2
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

    def dup
      duplicated_item = super
      duplicated_item.discount = discount.dup if discount
      duplicated_item.container = nil
      duplicated_item
    end
  end
end
