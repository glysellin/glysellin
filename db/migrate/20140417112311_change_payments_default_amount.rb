class ChangePaymentsDefaultAmount < ActiveRecord::Migration
  def up
    change_column_default :glysellin_payments, :amount, 0
  end

  def down
    change_column_default :glysellin_payments, :amount, nil
  end
end
