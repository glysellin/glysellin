# This migration comes from glysellin_engine (originally 20140312183753)
class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :glysellin_discounts do |t|
      t.string :name
      t.decimal :value
      t.integer :discount_type_id
      t.integer :discountable_id
      t.string :discountable_type

      t.timestamps
    end
  end
end
