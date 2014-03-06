class AddDiscountAndDiscountUnitToLineItems < ActiveRecord::Migration
  def change
    add_column :glysellin_line_items, :discount, :decimal, scale: 2, precision: 11
    add_column :glysellin_line_items, :discount_unit, :string
  end
end
