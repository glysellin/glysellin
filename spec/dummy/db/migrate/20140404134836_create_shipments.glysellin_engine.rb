# This migration comes from glysellin_engine (originally 20140313162659)
class CreateShipments < ActiveRecord::Migration
  def change
    create_table :glysellin_shipments do |t|
      t.integer :order_id
      t.integer :shipping_method_id
      t.datetime :sent_on
      t.decimal :eot_price, scale: 2, precision: 11
      t.decimal :price, scale: 2, precision: 11
      t.string :tracking_code

      t.timestamps
    end
  end
end
