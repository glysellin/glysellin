class RenameGlysellinProductsTableToGlysellinSellables < ActiveRecord::Migration
  def change
    rename_table :glysellin_products, :glysellin_sellables
  end
end
