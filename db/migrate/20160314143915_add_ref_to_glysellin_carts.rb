class AddRefToGlysellinCarts < ActiveRecord::Migration
  def up
    add_column :glysellin_carts, :ref, :string

    Glysellin::Cart.find_each do |cart|
      cart.send(:ensure_ref!)
    end
  end

  def down
    remove_column :glysellin_carts, :ref
  end
end
