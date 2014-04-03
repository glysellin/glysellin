module Glysellin
  class PropertyTypeSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :properties, embed: :ids, include: true
  end
end