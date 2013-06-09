class RemoveUnusedProductPropertiesColumns < ActiveRecord::Migration
  def up
    change_table :glysellin_product_properties do |t|
      t.remove :name, :adjustement, :variant_type
    end
  end

  def down
    change_table :glysellin_product_properties do |t|
      t.string   :name
      t.decimal  :adjustement,  :precision => 11, :scale => 2
      t.string   :variant_type
    end
  end
end