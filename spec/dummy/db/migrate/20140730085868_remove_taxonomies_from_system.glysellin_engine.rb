# This migration comes from glysellin_engine (originally 20130609025800)
class RemoveTaxonomiesFromSystem < ActiveRecord::Migration
  def up
    drop_table :glysellin_taxonomies
    drop_table :glysellin_products_taxonomies
  end

  def down
    create_table :glysellin_taxonomies do |t|
      t.string :name
      t.string :slug
      t.integer :parent_taxonomy_id

      t.timestamps
    end

    create_table :glysellin_products_taxonomies, :id => false do |t|
      t.integer :product_id
      t.integer :taxonomy_id
    end
  end
end
