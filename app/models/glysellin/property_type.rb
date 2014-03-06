module Glysellin
  class PropertyType < ActiveRecord::Base
    self.table_name = 'glysellin_property_types'

    has_many :properties, class_name: 'Glysellin::Property'
    has_many :variant_properties, class_name: 'Glysellin::VariantProperty', through: :properties
  end
end