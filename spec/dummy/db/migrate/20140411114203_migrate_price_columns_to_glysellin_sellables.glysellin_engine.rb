# This migration comes from glysellin_engine (originally 20140330184648)
class MigratePriceColumnsToGlysellinSellables < ActiveRecord::Migration
  def up
    change_table :glysellin_sellables do |t|
      t.decimal :eot_price, precision: 11, scale: 2
      t.decimal :price, precision: 11, scale: 2
      t.decimal :weight, precision: 11, scale: 3
    end

    change_table :glysellin_variants do |t|
      t.remove :eot_price
      t.remove :price
      t.remove :weight
    end
  end

  def down
    change_table :glysellin_variants do |t|
      t.decimal :eot_price, precision: 11, scale: 2
      t.decimal :price, precision: 11, scale: 2
      t.decimal :weight, precision: 11, scale: 3
    end

    change_table :glysellin_sellables do |t|
      t.remove :eot_price
      t.remove :price
      t.remove :weight
    end
  end
end
