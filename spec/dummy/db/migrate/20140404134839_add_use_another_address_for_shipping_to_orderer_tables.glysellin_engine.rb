# This migration comes from glysellin_engine (originally 20140319095929)
class AddUseAnotherAddressForShippingToOrdererTables < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :use_another_address_for_shipping, :boolean, default: false
    add_column :glysellin_customers, :use_another_address_for_shipping, :boolean, default: false
  end
end
