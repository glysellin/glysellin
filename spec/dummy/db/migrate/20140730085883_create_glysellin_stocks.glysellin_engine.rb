# This migration comes from glysellin_engine (originally 20140221145428)
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
