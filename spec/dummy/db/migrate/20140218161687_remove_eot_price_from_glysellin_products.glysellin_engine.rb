# This migration comes from glysellin_engine (originally 20130212154943)
class RemoveEotPriceFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :eot_price
  end

  def down
    add_column :glysellin_products, :eot_price, :decimal
  end
end
