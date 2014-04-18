module Glysellin
  class SellableSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :name, :description, :vat_rate, :eot_price, :price, :weight,
      :unlimited_stock, :barcode_ref, :variant_ids
  end
end
