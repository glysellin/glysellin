# This migration comes from glysellin_engine (originally 20130221102200)
class AddUnmarkedPriceToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :unmarked_price, :decimal, precision: 11, scale: 2
  end
end
