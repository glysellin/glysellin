class Glysellin::CustomerType < ActiveRecord::Base
    self.table_name = "glysellin_customer_types"
  has_many :customers, dependent: :nullify
  has_many :customer_types_variants, dependent: :destroy, class_name: 'Glysellin::CustomerTypesVariant'
end
