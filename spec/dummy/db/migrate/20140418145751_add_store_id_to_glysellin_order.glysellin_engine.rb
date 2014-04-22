# This migration comes from glysellin_engine (originally 20140411151919)
class AddStoreIdToGlysellinOrder < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :store_id, :integer
  end
end
