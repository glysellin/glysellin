class AddOrderIdToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :order_id, :integer
  end
end
