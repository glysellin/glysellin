# This migration comes from glysellin_engine (originally 20140221153654)
class RemoveIllimitedStockFromVariant < ActiveRecord::Migration
  def change
    remove_column :glysellin_variants, :unlimited_stock
    add_column :glysellin_sellables, :unlimited_stock, :boolean, default: false
  end
end
