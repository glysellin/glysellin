class RemoveInStockFromVariants < ActiveRecord::Migration
  def change
    remove_column :glysellin_variants, :in_stock
  end
end
