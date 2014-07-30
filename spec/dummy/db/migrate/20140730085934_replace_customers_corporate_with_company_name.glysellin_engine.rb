# This migration comes from glysellin_engine (originally 20140610065747)
class ReplaceCustomersCorporateWithCompanyName < ActiveRecord::Migration
  def change
    rename_column :glysellin_customers, :corporate, :company_name
  end
end
