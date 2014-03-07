module Glysellin
  class Property < ActiveRecord::Base
    self.table_name = 'glysellin_properties'

    has_many :variant_properties, class_name: 'Glysellin::VariantProperty', dependent: :destroy, inverse_of: :variant
    has_many :variants, class_name: 'Glysellin::Variant', through: :variant_properties
    belongs_to :property_type, class_name: 'Glysellin::PropertyType'
  end
end