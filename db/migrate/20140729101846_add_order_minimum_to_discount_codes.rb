class AddOrderMinimumToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :glysellin_discount_codes, :order_minimum, :decimal
  end
end
