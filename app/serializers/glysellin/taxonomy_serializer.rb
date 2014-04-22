module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :barcode_ref, :parent_id, :deep_children_ids, :deep_sellables_count
    has_many :children, include: true
  end
end
