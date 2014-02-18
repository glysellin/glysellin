# This migration comes from glysellin_engine (originally 20130211152651)
class AddProductIdToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :product_id, :integer
  end
end
