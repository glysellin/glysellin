# This migration comes from glysellin_engine (originally 20140218162821)
class AddNameToGlysellinSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :name, :string
  end
end
