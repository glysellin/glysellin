# This migration comes from glysellin_engine (originally 20140221145128)
class CreateGlysellinStores < ActiveRecord::Migration
  def change
    create_table :glysellin_stores do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :country
      t.string :phone

      t.timestamps
    end
  end
end
