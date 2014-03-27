module Glysellin
  class VariantSerializer < ActiveModel::Serializer
    attributes :id, :sku, :name, :eot_price, :vat_rate

    def vat_rate
      object.sellable.vat_rate
    end
  end
end
