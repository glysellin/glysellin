# This migration comes from glysellin_engine (originally 20140220093342)
class FixEmailDefinitionInCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :email, :string
  end
end
