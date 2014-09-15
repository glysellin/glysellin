class AddPricePerSixToGlysellinCustomerTypeVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_customer_type_variants, :price_per_six, :decimal
  end
end
