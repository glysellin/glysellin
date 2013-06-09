class AddVariantIdToGlysellinLineItems < ActiveRecord::Migration
  def change
    add_column :glysellin_line_items, :variant_id, :integer
  end
end