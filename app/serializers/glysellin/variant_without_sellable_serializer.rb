module Glysellin
  class VariantWithoutSellableSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :sku, :name, :eot_price, :price, :vat_rate, :images

    has_many :stocks, include: true
    has_many :variant_properties, include: true

    def stocks
      object.stocks.select { |stock| stock.store_id == scope.store_id }
    end

    def images
      object.variant_images.map { |vi| vi.image.url(:thumb) }
    end

    def vat_rate
      object.sellable.vat_rate
    end
  end
end
