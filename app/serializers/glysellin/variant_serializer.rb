module Glysellin
  class VariantSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :sku, :name, :eot_price, :price, :vat_rate

    has_many :stocks
    has_many :variant_properties

    def vat_rate
      object.sellable.vat_rate
    end
  end
end
