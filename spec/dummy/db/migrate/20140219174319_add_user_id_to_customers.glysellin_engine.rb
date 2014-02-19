# This migration comes from glysellin_engine (originally 20140219174227)
class AddUserIdToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :user_id, :integer
  end
end
