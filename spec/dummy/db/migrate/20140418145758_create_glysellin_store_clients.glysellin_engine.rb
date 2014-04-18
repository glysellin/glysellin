# This migration comes from glysellin_engine (originally 20140416215109)
class CreateGlysellinStoreClients < ActiveRecord::Migration
  def change
    create_table :glysellin_store_clients do |t|
      t.string :name
      t.string :key
      t.integer :store_id

      t.timestamps
    end
  end
end
