# This migration comes from glysellin_engine (originally 20140410110815)
class AddDepthToTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :ancestry_depth, :integer, default: 0
  end
end
