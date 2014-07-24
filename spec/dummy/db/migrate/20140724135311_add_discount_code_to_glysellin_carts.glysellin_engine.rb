# This migration comes from glysellin_engine (originally 20140417084703)
class AddDiscountCodeToGlysellinCarts < ActiveRecord::Migration
  def change
    add_column :glysellin_carts, :discount_code, :string
  end
end
