class AddSlugToGlysellinTaxonomies < ActiveRecord::Migration
  def up
    add_column :glysellin_taxonomies, :slug, :string
    add_index :glysellin_taxonomies, :slug

    Glysellin::Taxonomy.find_each(&:save!)
  end

  def down
    remove_index :glysellin_taxonomies, :slug
    remove_column :glysellin_taxonomies, :slug
  end
end
