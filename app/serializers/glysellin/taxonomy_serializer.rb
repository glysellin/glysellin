module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :barcode_ref, :parent_id, :deep_children_ids
    has_many :children, include: true
    has_many :sellables, include: true
  end
end
