module Glysellin
  class TaxonomiesMenuSerializer < ActiveModel::Serializer
    embed :ids, include: true
    attributes :id, :name, :barcode_ref
  end
end
