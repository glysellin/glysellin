# This migration comes from glysellin_engine (originally 20130204121211)
class CreateGlysellinDiscountTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_discount_types do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
