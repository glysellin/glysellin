class AddDescriptionToGlysellinSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :description, :text
  end
end
