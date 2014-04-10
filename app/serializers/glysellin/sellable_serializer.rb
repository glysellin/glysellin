module Glysellin
  class SellableSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :name, :description, :vat_rate, :eot_price, :price, :weight,
      :unlimited_stock, :barcode_ref

    has_one :taxonomy
    has_one :brand
    has_many :variants, include: false
  end
end