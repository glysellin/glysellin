module Glysellin
  class StockSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :count, :available_stock

    has_one :variant
    has_one :store

    def available_stock
      object.available_stock.to_i
    end
  end
end
