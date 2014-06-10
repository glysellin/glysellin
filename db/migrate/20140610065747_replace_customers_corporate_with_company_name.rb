class ReplaceCustomersCorporateWithCompanyName < ActiveRecord::Migration
  def change
    rename_column :glysellin_customers, :corporate, :company_name
  end
end
