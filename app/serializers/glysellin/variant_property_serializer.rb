module Glysellin
  class VariantPropertySerializer < ActiveModel::Serializer
    embed :ids

    attributes :id

    has_one :variant
    has_one :property, include: true
  end
end
