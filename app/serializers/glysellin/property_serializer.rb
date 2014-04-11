module Glysellin
  class PropertySerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :value, :barcode_ref

    has_one :property_type, include: true
  end
end
