class AddDefaultTaxonomyToGlysellinStoreClients < ActiveRecord::Migration
  def change
    add_column :glysellin_store_clients, :default_taxonomy_id, :integer
  end
end
