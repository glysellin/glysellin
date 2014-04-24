module Glysellin
  class SellableSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :name, :description, :vat_rate, :eot_price, :price, :weight, :unlimited_stock, :barcode_ref
    
    has_many :variants, include: true
    has_many :variant_images, include: true
  end
end
