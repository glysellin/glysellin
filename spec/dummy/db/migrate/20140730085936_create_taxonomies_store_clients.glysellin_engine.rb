# This migration comes from glysellin_engine (originally 20140619142436)
class CreateTaxonomiesStoreClients < ActiveRecord::Migration
  def change
    create_table :taxonomies_store_clients do |t|
      t.references :taxonomy
      t.references :store_client
      t.timestamps
    end
  end
end
