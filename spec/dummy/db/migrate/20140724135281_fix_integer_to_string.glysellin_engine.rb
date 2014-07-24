# This migration comes from glysellin_engine (originally 20140306133202)
class FixIntegerToString < ActiveRecord::Migration
  def change
  	remove_column :glysellin_property_types, :name
  	add_column :glysellin_property_types, :name, :string
  end
end
