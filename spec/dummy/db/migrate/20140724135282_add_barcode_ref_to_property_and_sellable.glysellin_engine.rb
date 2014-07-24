# This migration comes from glysellin_engine (originally 20140307132405)
class AddBarcodeRefToPropertyAndSellable < ActiveRecord::Migration
  def change
  	add_column :glysellin_properties, :barcode_ref, :string
  	add_column :glysellin_sellables, :barcode_ref, :string
  end
end
