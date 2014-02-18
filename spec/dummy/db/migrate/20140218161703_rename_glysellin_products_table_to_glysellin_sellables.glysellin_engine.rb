# This migration comes from glysellin_engine (originally 20140218155042)
class RenameGlysellinProductsTableToGlysellinSellables < ActiveRecord::Migration
  def change
    rename_table :glysellin_products, :glysellin_sellables
  end
end
