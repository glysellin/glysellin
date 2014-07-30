# This migration comes from glysellin_engine (originally 20130609013900)
class AddSellableReferencesToGlysellinProducts < ActiveRecord::Migration
  def change
    add_column :glysellin_products, :sellable_type, :string
    add_column :glysellin_products, :sellable_id, :integer
  end
end
