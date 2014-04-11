module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :name, :barcode_ref, :parent_id
    has_many :children, serializer: TaxonomyWithoutChildrenSerializer
  end
end
