class AddFullPathToTaxonomy < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :full_path, :text
  end
end
