module Glysellin
  class VariantProperty < ActiveRecord::Base
    self.table_name = 'glysellin_variant_properties'

    belongs_to :variant, class_name: "Glysellin::Variant",inverse_of: :properties

    has_many :properties, class_name: 'Glysellin::Property'
    has_many :property_types, class_name: 'Glysellin::PropertyType', through: :properties
  end
end