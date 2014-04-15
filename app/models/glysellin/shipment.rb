module Glysellin
  class Shipment < ActiveRecord::Base
    self.table_name = "glysellin_shipments"

    belongs_to :order, class_name: "Glysellin::Order", autosave: true
    belongs_to :shipping_method, class_name: "Glysellin::ShippingMethod"

    state_machine initial: :pending do
      event :ship do
        transition :pending => :shipped
      end

      event :cancel do
        transition :shipped => :pending
      end

      state :pending do
        before_save :ship, if: :sent_on
      end

      before_transition on: :ship, do: :migrate_stocks
      before_transition on: :cancel, do: :reset_shipment
    end

    def vat_rate
      (1 - (eot_price / price)) * 100
    end

    def total_vat
      price - eot_price
    end

    private

    def migrate_stocks
      stock_migration.apply
    end

    def rollback_stocks
      stock_migration.rollback
    end

    def stock_migration
      Glysellin::OrderStockMigration.new(order)
    end

    def reset_shipment
      rollback_stocks
      self.sent_on = nil
    end
  end
end
