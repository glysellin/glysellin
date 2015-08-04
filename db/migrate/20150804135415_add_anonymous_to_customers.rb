class AddAnonymousToCustomers < ActiveRecord::Migration
  def change
    add_column :glysellin_customers, :anonymous, :boolean, default: false
  end
end
