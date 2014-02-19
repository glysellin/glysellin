# This migration comes from glysellin_engine (originally 20140218165003)
class AddAttrsToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :first_name, :string
    add_column :glysellin_customers, :last_name, :string
  end
end
