class ChangePricesCacheColumnsToDecimalsInOrders < ActiveRecord::Migration
  def up
    remove_column :glysellin_orders, :total_eot_price_cache
    remove_column :glysellin_orders, :total_price_cache

    add_column :glysellin_orders, :total_eot_price_cache, :decimal, precision: 11, scale: 2
    add_column :glysellin_orders, :total_price_cache, :decimal, precision: 11, scale: 2

    Glysellin::Order.find_each(&:set_prices_cache_columns)
  end

  def down
    remove_column :glysellin_orders, :total_eot_price_cache
    remove_column :glysellin_orders, :total_price_cache

    add_column :glysellin_orders, :total_eot_price_cache, :string
    add_column :glysellin_orders, :total_price_cache, :string
  end
end
