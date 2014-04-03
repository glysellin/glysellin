class FixEmailDefinitionInCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :email, :string
  end
end
