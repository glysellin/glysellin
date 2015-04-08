class Glysellin::Stock < ActiveRecord::Base
  self.table_name = "glysellin_stocks"

  belongs_to :store, class_name: 'Glysellin::Store'
  belongs_to :variant, class_name: 'Glysellin::Variant'

  validates :count, presence: true
  validates_numericality_of :count

  def available_stock
    @available_stock ||= Glysellin::AvailableStock.new(self)
  end

  def threshold
    read_attribute(:threshold) || Glysellin.default_stock_alert_threshold
  end

  def withdraw(quantity)
    self.count -= quantity
  end

  def deposit(quantity)
    self.count += quantity
  end
end
