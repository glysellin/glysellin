# This migration comes from glysellin_engine (originally 20130212131658)
class AddWeightToGlysellinVariants < ActiveRecord::Migration
  def change
    add_column :glysellin_variants, :weight, :decimal
  end
end
