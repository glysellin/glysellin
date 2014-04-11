# This migration comes from glysellin_engine (originally 20130205120541)
class AddWeightToGlysellinOrderItems < ActiveRecord::Migration
  def change
    add_column :glysellin_order_items, :weight, :decimal, precision: 11, scale: 3
  end
end
