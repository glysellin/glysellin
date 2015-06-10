class AddSlugToGlysellinSellables < ActiveRecord::Migration
  def up
    add_column :glysellin_sellables, :slug, :string
    add_index :glysellin_sellables, :slug

    Glysellin::Sellable.find_each(&:save!)
  end

  def down
    remove_index :glysellin_sellables, :slug
    remove_column :glysellin_sellables, :slug
  end
end
