# This migration comes from glysellin_engine (originally 20140313105404)
class RemoveBarcodeReplaceWithSku < ActiveRecord::Migration
  def change
    remove_column :glysellin_variants, :barcode
  end
end
