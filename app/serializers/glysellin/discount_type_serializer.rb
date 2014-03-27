module Glysellin
  class DiscountTypeSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier
  end
end