class AddPriceFieldsToGlysellinShippingMethods < ActiveRecord::Migration
  def change
    add_column :glysellin_shipping_methods, :eot_price, :decimal, precision: 11, scale: 2
    add_column :glysellin_shipping_methods, :price, :decimal, precision: 11, scale: 2
  end
end
