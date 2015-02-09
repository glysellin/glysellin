# This migration comes from glysellin_engine (originally 20140915160605)
class AddPricePerSixToGlysellinCustomerTypeVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_customer_type_variants, :price_per_six, :decimal
  end
end
