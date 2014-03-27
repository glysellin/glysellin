module Glysellin
  class ShipmentSerializer < ActiveModel::Serializer
    attributes :id, :sent_on, :eot_price, :price, :tracking_code

    has_one :shipping_method, embed: :ids, include: true
  end
end
