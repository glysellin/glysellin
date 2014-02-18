class AddNameToGlysellinSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :name, :string
  end
end
