class AddVatRateToGlysellinCustomerTypesVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_customer_types_variants, :vat_rate, :decimal, precision: 11, scale: 2
  end
end
