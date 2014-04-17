class AddOrderIdToGlysellinCarts < ActiveRecord::Migration
  def change
    add_column :glysellin_carts, :order_id, :integer
  end
end
