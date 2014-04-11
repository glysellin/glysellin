module Glysellin
  class LineItemSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :eot_price, :name, :price, :quantity, :sku, :variant_id,
      :vat_rate

    has_one :discount
    has_one :variant, include: true
    has_one :parcel
  end
end
