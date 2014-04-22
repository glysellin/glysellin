class CreateGlysellinInvoices < ActiveRecord::Migration
  def change
    create_table :glysellin_invoices do |t|
      t.string :number
      t.integer :order_id

      t.timestamps
    end
  end
end
