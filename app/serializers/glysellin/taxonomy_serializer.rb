module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    embed :ids, include: true
    attributes :id, :name, :barcode_ref, :parent_id, :deep_sellables_count, :deep_children_ids
    has_many :children
    has_many :sellables
  end
end
