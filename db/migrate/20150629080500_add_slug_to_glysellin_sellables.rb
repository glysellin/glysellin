class AddSlugToGlysellinSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :slug, :string
    add_index :glysellin_sellables, :slug, unique: true
  end
end
