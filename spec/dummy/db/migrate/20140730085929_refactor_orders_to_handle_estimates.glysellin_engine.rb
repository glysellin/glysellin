# This migration comes from glysellin_engine (originally 20140513114114)
class RefactorOrdersToHandleEstimates < ActiveRecord::Migration
  def up
    add_column :glysellin_orders, :type, :string

    Glysellin::AbstractOrder.find_each do |order|
      order.update_column(:type, 'Glysellin::Order')
    end
  end

  def down
    remove_column :glysellin_orders, :type
  end
end
