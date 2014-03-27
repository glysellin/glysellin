module Glysellin
  class ShippingMethodSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier
  end
end