class AddSlugToGlysellinTaxonomies < ActiveRecord::Migration
  def change
    add_column :glysellin_taxonomies, :slug, :string
    add_index :glysellin_taxonomies, :slug, unique: true
  end
end
