class Glysellin::CustomerTypesVariant < ActiveRecord::Base
  self.table_name = "glysellin_customer_types_variants"

  belongs_to :customer_type, class_name: 'Glysellin::CustomerType'
  belongs_to :variant, class_name: 'Glysellin::Variant'

  def vat_rate
    read_attribute(:vat_rate) || customer_type.try(:default_vat_rate) ||
      variant.try(:sellable).try(:vat_rate) || Glysellin.default_vat_rate
  end
end
