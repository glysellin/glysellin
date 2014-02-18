# This migration comes from glysellin_engine (originally 20130212132253)
class RemoveVariantColumnsFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :price
    remove_column :glysellin_products, :in_stock
    remove_column :glysellin_products, :unlimited_stock
    remove_column :glysellin_products, :weight
  end

  def down
    add_column :glysellin_products, :price, :decimal
    add_column :glysellin_products, :in_stock, :integer
    add_column :glysellin_products, :unlimited_stock, :boolean
    add_column :glysellin_products, :weight, :boolean
  end
end
