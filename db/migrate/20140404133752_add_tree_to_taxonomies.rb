class AddTreeToTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :ancestry, :string
    add_index :glysellin_taxonomies, :ancestry
  end
end
