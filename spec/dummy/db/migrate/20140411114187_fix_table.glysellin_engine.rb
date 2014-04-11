# This migration comes from glysellin_engine (originally 20140306125529)
class FixTable < ActiveRecord::Migration
  def change
  	drop_table :glysellin_property_types
    create_table :glysellin_property_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
