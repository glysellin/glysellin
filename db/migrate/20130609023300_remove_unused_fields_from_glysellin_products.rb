class RemoveUnusedFieldsFromGlysellinProducts < ActiveRecord::Migration
  def up
    remove_column :glysellin_products, :name, :description, :display_priority,
      :position, :slug, :sku, :published
  end

  def down
    change_table :glysellin_products do |t|
      t.string :name
      t.text :description
      t.integer :display_priority
      t.integer :position
      t.string :slug
      t.string :sku
      t.boolean :published, default: true
    end
  end
end