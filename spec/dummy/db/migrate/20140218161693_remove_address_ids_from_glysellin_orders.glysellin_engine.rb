# This migration comes from glysellin_engine (originally 20130325113903)
class RemoveAddressIdsFromGlysellinOrders < ActiveRecord::Migration
  def up
    remove_column :glysellin_orders, :billing_address_id
    remove_column :glysellin_orders, :shipping_address_id
  end

  def down
    add_column :glysellin_orders, :shipping_address_id, :integer
    add_column :glysellin_orders, :billing_address_id, :integer
  end
end
