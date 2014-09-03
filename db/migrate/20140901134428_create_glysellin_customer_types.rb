class CreateGlysellinCustomerTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_customer_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
