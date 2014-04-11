module Glysellin
  class ParcelSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :name

    has_many :line_items, include: true

    has_one :sendable, polymorphic: true
  end
end