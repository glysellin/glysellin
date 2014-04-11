class AddStoreIdToGlysellinOrder < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :store_id, :integer
  end
end
