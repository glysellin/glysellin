class MakeVariantsBelongToSellablesAndNotProducts < ActiveRecord::Migration
  def up
    change_table :glysellin_variants do |t|
      t.integer :sellable_id
      t.string :sellable_type
      t.remove :product_id
    end
  end

  def down
    change_table :glysellin_variants do |t|
      t.integer :product_id
      t.remove :sellable_id, :sellable_type
    end
  end
end