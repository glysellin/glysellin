class MoveLineItemsToParcels < ActiveRecord::Migration
  def up
    remove_column :glysellin_line_items, :order_id
  end

  def down
    add_column :glysellin_line_items, :order_id, :integer
  end
end
