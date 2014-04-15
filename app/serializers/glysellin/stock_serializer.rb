module Glysellin
  class StockSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :count, :available_stock

    has_one :variant
    has_one :store, include: true

    def available_stock
      object.available_stock.to_i
    end
  end
end
