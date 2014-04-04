# This migration comes from glysellin_engine (originally 20140311151041)
class RemoveDiscountFieldsFromVariants < ActiveRecord::Migration
  def up
    remove_column :glysellin_line_items, :discount
    remove_column :glysellin_line_items, :discount_unit
  end

  def down
    add_column :glysellin_line_items, :discount, :decimal, scale: 2, precision: 11
    add_column :glysellin_line_items, :discount_unit, :string
  end
end
