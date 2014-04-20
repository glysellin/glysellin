module Glysellin
  class ShipmentSerializer < ActiveModel::Serializer
    attributes :id, :sent_on, :eot_price, :price, :tracking_code

    has_one :shipping_method, embed: :ids, include: true

    has_one :order

    def order
      object.shippable
    end
  end
end
