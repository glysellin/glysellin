class AddAlertsEnabledToGlysellinStores < ActiveRecord::Migration
  def change
    add_column :glysellin_stores, :alerts_enabled, :boolean, default: true
  end
end
