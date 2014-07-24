# This migration comes from glysellin_engine (originally 20140619145641)
class AddDefaultTaxonomyToGlysellinStoreClients < ActiveRecord::Migration
  def change
    add_column :glysellin_store_clients, :default_taxonomy_id, :integer
  end
end
