class CreateGlysellinStocks < ActiveRecord::Migration
  def change
    create_table :glysellin_stocks do |t|
      t.integer :count
      t.references :store
      t.references :variant
      t.timestamps
    end
  end
end
