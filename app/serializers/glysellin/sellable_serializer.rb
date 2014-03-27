module Glysellin
  class SellableSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :vat_rate, :unlimited_stock, :barcode_ref

    has_one :taxonomy
    has_one :brand
    has_many :variants
  end
end