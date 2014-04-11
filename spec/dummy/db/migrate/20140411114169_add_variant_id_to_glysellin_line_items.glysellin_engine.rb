# This migration comes from glysellin_engine (originally 20130609142100)
class AddVariantIdToGlysellinLineItems < ActiveRecord::Migration
  def change
    add_column :glysellin_line_items, :variant_id, :integer
  end
end