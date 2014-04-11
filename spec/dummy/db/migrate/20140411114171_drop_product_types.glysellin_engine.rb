# This migration comes from glysellin_engine (originally 20130609193600)
class DropProductTypes < ActiveRecord::Migration
  def up
    drop_table :glysellin_product_types
    drop_table :glysellin_product_types_properties

    remove_column :glysellin_products, :product_type_id
  end

  def down
    create_table :glysellin_product_types_properties, id: false do |t|
      t.references :product_type, :product_property
    end

    create_table :glysellin_product_types do |t|
      t.string   :name
      t.timestamps
    end

    add_column :glysellin_products, :product_type_id, :integer
    add_column :glysellin_product_types_properties, :product_type_id, :integer
  end
end