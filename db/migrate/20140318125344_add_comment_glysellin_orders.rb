class AddCommentGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :comment, :text
  end
end
