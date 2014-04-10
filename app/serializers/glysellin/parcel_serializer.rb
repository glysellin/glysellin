module Glysellin
  class ParcelSerializer < ActiveModel::Serializer
    embed :ids

    attributes :name

    has_many :line_items
    has_one :sendable, polymorphic: true
  end
end