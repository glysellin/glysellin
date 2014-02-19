# This migration comes from glysellin_engine (originally 20130204202102)
class CreateGlysellinShippingMethods < ActiveRecord::Migration
  def change
    create_table :glysellin_shipping_methods do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end

    add_index :glysellin_shipping_methods, :identifier
  end
end
