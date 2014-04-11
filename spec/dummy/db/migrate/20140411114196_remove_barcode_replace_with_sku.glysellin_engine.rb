# This migration comes from glysellin_engine (originally 20140313105404)
class RemoveBarcodeReplaceWithSku < ActiveRecord::Migration
  def up
    remove_column :glysellin_variants, :barcode
  end

  def down
    add_column :glysellin_variants, :barcode, :string
  end
end
