# This migration comes from glysellin_engine (originally 20140722095249)
class RemoveOldSellablesAndVariantsFields < ActiveRecord::Migration
  def up
    change_table :glysellin_sellables do |t|
      t.remove :sellable_type
      t.remove :sellable_id
      t.remove :barcode_ref
    end

    remove_column :glysellin_variants, :sellable_type
  end

  def down
    add_column :glysellin_variants, :sellable_type, :string

    change_table :glysellin_sellables do |t|
      t.string :sellable_type
      t.integer :sellable_id
      t.string :barcode_ref
    end
  end
end
