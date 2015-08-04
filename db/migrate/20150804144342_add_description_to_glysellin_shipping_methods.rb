class AddDescriptionToGlysellinShippingMethods < ActiveRecord::Migration
  def change
    add_column :glysellin_shipping_methods, :description, :text
  end
end
