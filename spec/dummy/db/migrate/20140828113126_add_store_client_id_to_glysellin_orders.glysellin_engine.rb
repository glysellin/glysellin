# This migration comes from glysellin_engine (originally 20140806105940)
class AddStoreClientIdToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :store_client_id, :integer
  end
end
