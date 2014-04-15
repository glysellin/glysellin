class AddStateToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :state, :string
  end
end
