# This migration comes from glysellin_engine (originally 20140318125344)
class AddCommentGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :comment, :text
  end
end
