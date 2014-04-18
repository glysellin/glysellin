# This migration comes from glysellin_engine (originally 20140416155002)
class CreateGlysellinCarts < ActiveRecord::Migration
  def change
    create_table :glysellin_carts do |t|
      t.string :state
      t.boolean :use_another_address_for_shipping, default: false
      t.integer :customer_id
      t.integer :store_id

      t.timestamps
    end
  end
end
