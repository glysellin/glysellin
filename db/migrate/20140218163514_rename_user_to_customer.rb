class RenameUserToCustomer < ActiveRecord::Migration
  def change
    drop_table :glysellin_customers
    rename_table :users, :glysellin_customers

    remove_column :glysellin_customers, :encrypted_password
    remove_column :glysellin_customers, :reset_password_token
    remove_column :glysellin_customers, :reset_password_sent_at
    remove_column :glysellin_customers, :remember_created_at
    remove_column :glysellin_customers, :sign_in_count
    remove_column :glysellin_customers, :current_sign_in_at
    remove_column :glysellin_customers, :last_sign_in_at
    remove_column :glysellin_customers, :current_sign_in_ip
    remove_column :glysellin_customers, :last_sign_in_ip
  end
end
