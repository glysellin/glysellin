# This migration comes from glysellin_engine (originally 20140306124241)
class CreateNeededTablesForProperty < ActiveRecord::Migration
  def change
    create_table :glysellin_variant_properties do |t|
      t.integer :variant_id
      t.timestamps
    end

    create_table :glysellin_properties do |t|
      t.integer :property_type_id
      t.integer :variant_property_id
      t.timestamps
    end

    create_table :glysellin_property_types do |t|
      t.integer :name
      t.timestamps
    end
  end
end
