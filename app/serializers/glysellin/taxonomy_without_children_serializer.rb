module Glysellin
  class TaxonomyWithoutChildrenSerializer < ActiveModel::Serializer
    attributes :id, :name, :barcode_ref, :parent_id
    has_many :sellables
  end
end
