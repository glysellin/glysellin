# This migration comes from glysellin_engine (originally 20140219122814)
class AddCorporateToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :corporate, :string
  end
end
