# This migration comes from glysellin_engine (originally 20140220162535)
class AddTaxonomiesToSellable < ActiveRecord::Migration
  def change
    create_table :glysellin_taxonomies do |t|
      t.string :name
      t.text :description
    end

    add_column :glysellin_sellables, :taxonomy_id, :integer
  end
end
