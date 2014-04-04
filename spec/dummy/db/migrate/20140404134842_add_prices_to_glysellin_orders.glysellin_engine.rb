# This migration comes from glysellin_engine (originally 20140401164840)
class AddPricesToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :total_price, :decimal, precision: 11, scale: 2
    add_column :glysellin_orders, :total_eot_price, :decimal, precision: 11, scale: 2
  end
end
