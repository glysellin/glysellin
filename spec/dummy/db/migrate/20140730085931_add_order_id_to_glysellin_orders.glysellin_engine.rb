# This migration comes from glysellin_engine (originally 20140604152323)
class AddOrderIdToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :order_id, :integer
  end
end
