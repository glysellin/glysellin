module Glysellin
  class TaxonomySerializer < ActiveModel::Serializer
    attributes :id, :name, :barcode_ref
  end
end
