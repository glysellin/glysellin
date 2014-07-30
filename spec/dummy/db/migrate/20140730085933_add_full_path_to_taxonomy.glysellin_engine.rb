# This migration comes from glysellin_engine (originally 20140606125912)
class AddFullPathToTaxonomy < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :full_path, :text
  end
end
