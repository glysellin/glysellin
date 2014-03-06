module Glysellin
  class Property < ActiveRecord::Base
    self.table_name = 'glysellin_properties'

    belongs_to :variant_property, class_name: "Glysellin::VariantProperty"
    belongs_to :property_type, class_name: 'Glysellin::PropertyType'
  end
end