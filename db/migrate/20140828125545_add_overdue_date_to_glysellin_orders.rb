class AddOverdueDateToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :overdue_date, :date
  end
end
