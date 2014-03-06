class AddNameToProperties < ActiveRecord::Migration
  def change
  	add_column :glysellin_properties, :name, :string
  end
end
