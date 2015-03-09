class AddDefaultVatRateToGlysellinCustomerTypes < ActiveRecord::Migration
  def change
    add_column :glysellin_customer_types, :default_vat_rate, :decimal, precision: 11, scale: 2
  end
end
