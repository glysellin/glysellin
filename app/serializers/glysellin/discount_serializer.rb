module Glysellin
  class DiscountSerializer < ActiveModel::Serializer
    attributes :id, :name, :value
    has_one :discount_type, embed: :ids, include: true
    has_one :discountable, polymorphic: true, embed: :ids
  end
end