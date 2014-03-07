class AddBarcodeToVariants < ActiveRecord::Migration
  def change
  	add_column :glysellin_variants, :barcode, :string
  end
end
