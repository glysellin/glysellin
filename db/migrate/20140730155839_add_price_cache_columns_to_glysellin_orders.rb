class AddPriceCacheColumnsToGlysellinOrders < ActiveRecord::Migration
  def change
    add_column :glysellin_orders, :total_price_cache, :string
    add_column :glysellin_orders, :total_eot_price_cache, :string
  end
end
