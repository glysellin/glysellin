# This migration comes from glysellin_engine (originally 20140411113821)
class RemoveAncestry < ActiveRecord::Migration
  def change
    remove_column :glysellin_taxonomies, :ancestry
    remove_column :glysellin_taxonomies, :ancestry_depth
    add_column :glysellin_taxonomies, :parent_id, :integer
    add_index :glysellin_taxonomies, :parent_id
  end
end
