# This migration comes from glysellin_engine (originally 20140828113103)
class AddThresholdToGlysellinStocks < ActiveRecord::Migration
  def change
    add_column :glysellin_stocks, :threshold, :integer
  end
end
