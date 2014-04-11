# This migration comes from glysellin_engine (originally 20140306132145)
class FixAllTables < ActiveRecord::Migration
  def change
  	drop_table :glysellin_variant_properties
  	drop_table :glysellin_properties
  	drop_table :glysellin_property_types

    create_table :glysellin_variant_properties do |t|
      t.integer :variant_id
      t.integer :property_id
    end

    create_table :glysellin_properties do |t|
      t.string :value
      t.integer :property_type_id
      t.timestamps
    end

    create_table :glysellin_property_types do |t|
      t.integer :name
      t.timestamps
    end
  end
end
