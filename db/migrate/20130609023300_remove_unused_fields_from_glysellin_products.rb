class RemoveUnusedFieldsFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :description, :display_priority,
      :position, :slug, :sku
  end

  def down
    change_table :glysellin_products do |t|
      t.text :description
      t.integer :display_priority
      t.integer :position
      t.string :slug
      t.string :sku
    end
  end
end