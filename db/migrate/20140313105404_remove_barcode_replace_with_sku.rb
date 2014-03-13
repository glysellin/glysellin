class RemoveBarcodeReplaceWithSku < ActiveRecord::Migration
  def change
    remove_column :glysellin_variants, :barcode
  end
end
