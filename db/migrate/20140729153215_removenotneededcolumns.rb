class Removenotneededcolumns < ActiveRecord::Migration
  def change
    remove_column :glysellin_orders, :status
    remove_column :glysellin_orders, :paid_on
  end
end
