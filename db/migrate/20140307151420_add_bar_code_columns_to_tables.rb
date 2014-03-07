class AddBarCodeColumnsToTables < ActiveRecord::Migration
  def change
  	add_column :glysellin_property_types, :identifier, :string
  	add_column :glysellin_taxonomies, :barcode_ref, :string
  end
end
