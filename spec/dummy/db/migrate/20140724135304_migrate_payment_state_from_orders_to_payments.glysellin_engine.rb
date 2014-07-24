# This migration comes from glysellin_engine (originally 20140415085031)
class MigratePaymentStateFromOrdersToPayments < ActiveRecord::Migration
  def up
    remove_column :glysellin_payments, :status
    add_column :glysellin_payments, :state, :string
  end

  def down
    remove_column :glysellin_payments, :state
    add_column :glysellin_payments, :status, :string
  end
end
