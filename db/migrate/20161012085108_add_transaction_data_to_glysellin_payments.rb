class AddTransactionDataToGlysellinPayments < ActiveRecord::Migration
  def change
    add_column :glysellin_payments, :transaction_data, :jsonb
  end
end
