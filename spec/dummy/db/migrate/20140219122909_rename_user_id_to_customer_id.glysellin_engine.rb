# This migration comes from glysellin_engine (originally 20140218164618)
class RenameUserIdToCustomerId < ActiveRecord::Migration
  def change
    rename_column :glysellin_orders, :user_id, :customer_id
  end
end
