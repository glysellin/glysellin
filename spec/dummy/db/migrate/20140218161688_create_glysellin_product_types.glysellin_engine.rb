# This migration comes from glysellin_engine (originally 20130214184204)
class CreateGlysellinProductTypes < ActiveRecord::Migration
  def change
    create_table :glysellin_product_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
