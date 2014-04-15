module Glysellin
  class VariantSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :sku, :name, :eot_price, :price, :vat_rate

    has_many :stocks, include: true
    has_many :variant_properties, include: true
    has_one :sellable, include: true

    def vat_rate
      object.sellable.vat_rate
    end
  end
end
