class AddCorporateToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :corporate, :string
  end
end
