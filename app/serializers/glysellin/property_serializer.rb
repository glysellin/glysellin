module Glysellin
  class PropertySerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :value, :barcode_ref

    has_many :sellables
    has_one :property_type
  end
end
