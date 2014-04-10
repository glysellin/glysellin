module Glysellin
  class LineItemSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :eot_price, :name, :price, :quantity, :sku, :variant_id,
      :vat_rate, :order_id

    has_one :discount
    has_one :variant
    has_one :parcel
  end
end
