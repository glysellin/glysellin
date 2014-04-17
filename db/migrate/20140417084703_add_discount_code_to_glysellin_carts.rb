class AddDiscountCodeToGlysellinCarts < ActiveRecord::Migration
  def change
    add_column :glysellin_carts, :discount_code, :string
  end
end
