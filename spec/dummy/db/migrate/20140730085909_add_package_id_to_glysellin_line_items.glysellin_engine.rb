# This migration comes from glysellin_engine (originally 20140410180103)
class AddPackageIdToGlysellinLineItems < ActiveRecord::Migration
  def change
    add_column :glysellin_line_items, :package_id, :integer
  end
end
