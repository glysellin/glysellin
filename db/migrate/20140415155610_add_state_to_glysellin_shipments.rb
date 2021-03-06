class AddStateToGlysellinShipments < ActiveRecord::Migration
  def up
    add_column :glysellin_shipments, :state, :string
    remove_column :glysellin_orders, :shipment_state
  end

  def down
    add_column :glysellin_orders, :shipment_state, :string
    remove_column :glysellin_shipments, :state
  end
end
