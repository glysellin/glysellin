# This migration comes from glysellin_engine (originally 20140221154345)
class RemoveInStockFromVariants < ActiveRecord::Migration
  def change
    remove_column :glysellin_variants, :in_stock
  end
end
