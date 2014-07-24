# This migration comes from glysellin_engine (originally 20140513221732)
class AddVariantsCountToGlysellinSellables < ActiveRecord::Migration
  def up
    add_column :glysellin_sellables, :variants_count, :integer, default: 0

    Glysellin::Sellable.find_each do |sellable|
      Glysellin::Sellable.reset_counters(sellable.id, :variants)
    end
  end

  def down
    remove_column :glysellin_sellables, :variants_count
  end
end
