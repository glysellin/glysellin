module Glysellin
  class ParcelSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :name

    has_many :line_items, include: true
    has_one :order

    def order
      object.sendable
    end
  end
end
