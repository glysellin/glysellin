# This migration comes from glysellin_engine (originally 20140306130124)
class AddNameToProperties < ActiveRecord::Migration
  def change
  	add_column :glysellin_properties, :name, :string
  end
end
