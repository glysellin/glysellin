# This migration comes from glysellin_engine (originally 20130609040600)
class RenameOrderItemsToLineItems < ActiveRecord::Migration
  def change
    rename_table :glysellin_order_items, :glysellin_line_items
  end
end

