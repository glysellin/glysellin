# This migration comes from glysellin_engine (originally 20140220093342)
class FixEmailDefinitionInCustomers < ActiveRecord::Migration
  def change
    remove_column :glysellin_customers, :email
    add_column :glysellin_customers, :email, :string
  end
end
