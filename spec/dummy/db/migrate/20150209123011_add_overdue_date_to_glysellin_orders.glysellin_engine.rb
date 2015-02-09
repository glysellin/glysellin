# This migration comes from glysellin_engine (originally 20140828125545)
class AddOverdueDateToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :overdue_date, :date
  end
end
