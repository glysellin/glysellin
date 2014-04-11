# This migration comes from glysellin_engine (originally 20140324113826)
class AddPaymentStateAndShipmentStateToGlysellinOrders < ActiveRecord::Migration
  def up
    add_column :glysellin_orders, :payment_state, :string
    add_column :glysellin_orders, :shipment_state, :string
    remove_column :glysellin_orders, :state
  end

  def down
    add_column :glysellin_orders, :state, :string
    remove_column :glysellin_orders, :shipment_state
    remove_column :glysellin_orders, :payment_state
  end
end
