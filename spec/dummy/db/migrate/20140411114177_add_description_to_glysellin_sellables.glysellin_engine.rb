# This migration comes from glysellin_engine (originally 20140218173125)
class AddDescriptionToGlysellinSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :description, :text
  end
end
