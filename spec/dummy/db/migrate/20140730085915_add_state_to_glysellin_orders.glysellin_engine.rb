# This migration comes from glysellin_engine (originally 20140415093223)
class AddStateToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :state, :string
  end
end
