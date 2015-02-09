# This migration comes from glysellin_engine (originally 20140901144111)
class AddCustomerTypeToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :customer_type_id, :integer
  end
end
