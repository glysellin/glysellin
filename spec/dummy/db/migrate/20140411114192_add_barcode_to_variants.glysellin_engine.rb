# This migration comes from glysellin_engine (originally 20140307132757)
class AddBarcodeToVariants < ActiveRecord::Migration
  def change
  	add_column :glysellin_variants, :barcode, :string
  end
end
