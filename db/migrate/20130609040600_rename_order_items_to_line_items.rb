class RenameOrderItemsToLineItems < ActiveRecord::Migration
  def change
    rename_table :glysellin_order_items, :glysellin_line_items
  end
end

