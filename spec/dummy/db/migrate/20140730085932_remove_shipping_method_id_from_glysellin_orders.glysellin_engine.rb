# This migration comes from glysellin_engine (originally 20140606095148)
class RemoveShippingMethodIdFromGlysellinOrders < ActiveRecord::Migration
  def change
    remove_column :glysellin_orders, :shipping_method_id, :integer
  end
end
