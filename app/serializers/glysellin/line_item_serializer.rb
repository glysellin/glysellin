module Glysellin
  class LineItemSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :eot_price, :name, :price, :quantity, :sku, :variant_id,
      :vat_rate, :order_id

    has_one :discount
    has_one :variant
  end
end
