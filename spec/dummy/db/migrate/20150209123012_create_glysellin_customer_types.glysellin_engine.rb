# This migration comes from glysellin_engine (originally 20140901134428)
class CreateGlysellinCustomerTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_customer_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
