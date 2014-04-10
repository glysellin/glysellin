module Glysellin
  class DiscountSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :name, :value
    has_one :discount_type, include: true
    has_one :discountable, polymorphic: true
  end
end