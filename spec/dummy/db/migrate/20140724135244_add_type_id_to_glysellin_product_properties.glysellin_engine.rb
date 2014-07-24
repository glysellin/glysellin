# This migration comes from glysellin_engine (originally 20130211105557)
class AddTypeIdToGlysellinProductProperties < ActiveRecord::Migration
  def change
    add_column :glysellin_product_properties, :type_id, :integer
  end
end
