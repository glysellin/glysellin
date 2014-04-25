# This migration comes from glysellin_engine (originally 20140425161209)
class AddThumbToSellables < ActiveRecord::Migration
  def change
    add_column :glysellin_sellables, :thumb, :string
  end
end
