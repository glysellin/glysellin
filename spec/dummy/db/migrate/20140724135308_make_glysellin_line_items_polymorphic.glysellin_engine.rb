# This migration comes from glysellin_engine (originally 20140416161303)
class MakeGlysellinLineItemsPolymorphic < ActiveRecord::Migration
  def up
    change_table :glysellin_line_items do |t|
      t.remove :package_id
      t.references :container, polymorphic: true
    end
  end

  def down
    change_table :glysellin_line_items do |t|
      t.remove_references :container, polymorphic: true
      t.integer :package_id
    end
  end
end
