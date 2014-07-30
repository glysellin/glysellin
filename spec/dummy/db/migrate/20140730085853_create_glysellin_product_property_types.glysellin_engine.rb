# This migration comes from glysellin_engine (originally 20130208165020)
class CreateGlysellinProductPropertyTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_product_property_types do |t|
      t.string :name
    end
  end
end
