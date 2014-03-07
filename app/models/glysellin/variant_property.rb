module Glysellin
  class VariantProperty < ActiveRecord::Base
    self.table_name = 'glysellin_variant_properties'

    belongs_to :variant, class_name: "Glysellin::Variant"
    belongs_to :property, class_name: "Glysellin::Property"
  end
end