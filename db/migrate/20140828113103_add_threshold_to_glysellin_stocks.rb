class AddThresholdToGlysellinStocks < ActiveRecord::Migration
  def change
    add_column :glysellin_stocks, :threshold, :integer
  end
end
