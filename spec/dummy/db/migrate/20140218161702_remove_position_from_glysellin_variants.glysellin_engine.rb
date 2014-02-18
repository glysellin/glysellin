# This migration comes from glysellin_engine (originally 20130609200700)
class RemovePositionFromGlysellinVariants < ActiveRecord::Migration
  def up
    remove_column :glysellin_variants, :position
  end

  def down
    add_column :glysellin_variants, :position, :integer
  end
end
