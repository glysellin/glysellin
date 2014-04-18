module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :barcode_ref, :parent_id
    has_many :children, include: true, serializer: ShallowTaxonomySerializer
  end
end
