class Glysellin::CustomerTypesVariant < ActiveRecord::Base
    self.table_name = "glysellin_customer_types_variants"
  belongs_to :customer_type, class_name: 'Glysellin::CustomerType'
  belongs_to :variant, class_name: 'Glysellin::Variant'
end
