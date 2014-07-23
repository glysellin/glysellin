class AddPriceAndEotPriceToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :price, :decimal, precision: 11, scale: 2
    add_column :glysellin_variants, :eot_price, :decimal, precision: 11, scale: 2
  end
end
