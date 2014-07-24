# This migration comes from glysellin_engine (originally 20140417083124)
class MakeShipmentAndPaymentsPolymorphic < ActiveRecord::Migration
  def up
    change_table :glysellin_shipments do |t|
      t.remove :order_id
      t.references :shippable, polymorphic: true
    end

    change_table :glysellin_payments do |t|
      t.remove :order_id
      t.references :payable, polymorphic: true
    end
  end

  def down
    change_table :glysellin_shipments do |t|
      t.integer :order_id
      t.remove_references :shippable, polymorphic: true
    end

    change_table :glysellin_payments do |t|
      t.integer :order_id
      t.remove_references :payable, polymorphic: true
    end
  end
end
