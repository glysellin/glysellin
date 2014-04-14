module Glysellin
  class ShallowTaxonomySerializer < ActiveModel::Serializer
    attributes :id, :name, :barcode_ref, :parent_id
  end
end
