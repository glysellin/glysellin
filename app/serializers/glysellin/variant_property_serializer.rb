module Glysellin
  class VariantPropertySerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id

    has_one :variant
    has_one :property
  end
end
