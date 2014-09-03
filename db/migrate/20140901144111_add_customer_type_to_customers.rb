class AddCustomerTypeToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :customer_type_id, :integer
  end
end
