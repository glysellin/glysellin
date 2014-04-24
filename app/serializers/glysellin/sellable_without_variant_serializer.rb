module Glysellin
  class SellableWithoutVariantSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :name, :description, :vat_rate, :eot_price, :price, :weight,
      :unlimited_stock, :barcode_ref, :variant_ids
  
    has_many :variant_images
  end
end
