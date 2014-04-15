module Glysellin
  class SellableSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :name, :description, :vat_rate, :eot_price, :price, :weight,
      :unlimited_stock, :barcode_ref

    has_one :taxonomy, serializer: ShallowTaxonomySerializer, include: true
    has_one :brand, include: true
    has_many :variants
  end
end