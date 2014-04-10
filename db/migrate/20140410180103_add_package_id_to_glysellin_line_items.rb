class AddPackageIdToGlysellinLineItems < ActiveRecord::Migration
  def change
    add_column :glysellin_line_items, :package_id, :integer
  end
end
