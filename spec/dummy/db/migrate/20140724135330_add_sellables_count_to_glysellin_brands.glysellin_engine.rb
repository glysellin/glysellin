# This migration comes from glysellin_engine (originally 20140711124908)
class AddSellablesCountToGlysellinBrands < ActiveRecord::Migration
  def up
    add_column :glysellin_brands, :sellables_count, :integer, default: 0

    Glysellin::Brand.pluck(:id).each do |brand_id|
      Glysellin::Brand.reset_counters(brand_id, :sellables)
    end
  end

  def down
    remove_column :glysellin_brands, :sellables_count
  end
end
