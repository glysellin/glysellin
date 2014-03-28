module Glysellin
  class PropertySerializer < ActiveModel::Serializer
    attributes :id, :value

    has_one :property_type, embed: :ids, include: true
  end
end