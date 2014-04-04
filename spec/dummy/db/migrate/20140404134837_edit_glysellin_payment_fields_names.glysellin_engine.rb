# This migration comes from glysellin_engine (originally 20140314172233)
class EditGlysellinPaymentFieldsNames < ActiveRecord::Migration
  def change
    change_table :glysellin_payments do |t|
      t.rename :type_id, :payment_method_id
      t.rename :last_payment_action_on, :received_on
      t.decimal :amount, precision: 11, scale: 2
    end
  end
end
