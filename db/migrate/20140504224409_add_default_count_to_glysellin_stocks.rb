class AddDefaultCountToGlysellinStocks < ActiveRecord::Migration
  def up
    change_column :glysellin_stocks, :count, :integer, default: 0
  end

  def down
    change_column :glysellin_stocks, :count, :integer, default: nil
  end
end
