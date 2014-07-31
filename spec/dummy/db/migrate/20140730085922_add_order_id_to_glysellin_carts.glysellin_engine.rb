# This migration comes from glysellin_engine (originally 20140417110345)
class AddOrderIdToGlysellinCarts < ActiveRecord::Migration
  def change
    add_column :glysellin_carts, :order_id, :integer
  end
end
