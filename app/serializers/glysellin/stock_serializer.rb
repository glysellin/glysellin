module Glysellin
  class StockSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :count

    has_one :variant
    has_one :store
  end
end
