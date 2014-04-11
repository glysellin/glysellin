class AddDepthToTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :ancestry_depth, :integer, default: 0
  end
end
