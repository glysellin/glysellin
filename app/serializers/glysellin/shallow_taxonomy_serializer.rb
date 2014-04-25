module Glysellin
  class ShallowTaxonomySerializer < ActiveModel::Serializer
    embed :ids, include: true
    attributes :id, :name, :barcode_ref, :parent_id
  end
end
