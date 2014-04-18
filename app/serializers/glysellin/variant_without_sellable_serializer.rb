module Glysellin
  class VariantWithoutSellableSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :sku, :name, :eot_price, :price, :vat_rate

    has_many :stocks
    has_many :variant_properties, include: true

    def stocks
      object.stocks.select { |stock| stock.store_id == scope.store_id }
    end

    def vat_rate
      object.sellable.vat_rate
    end
  end
end
