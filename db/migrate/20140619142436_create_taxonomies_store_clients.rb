class CreateTaxonomiesStoreClients < ActiveRecord::Migration
  def change
    create_table :glysellin_taxonomies_store_clients do |t|
      t.references :taxonomy
      t.references :store_client
      t.timestamps
    end
  end
end
