class Glysellin::Store < ActiveRecord::Base
  self.table_name = "glysellin_stores"

  has_many :stocks, dependent: :destroy
  has_many :variants, through: :stocks

  has_many :orders, dependent: :nullify

  validates :name, presence: true

  scope :ordered, -> { order('glysellin_stores.name ASC') }
  scope :with_alerts_enabled, -> { where(alerts_enabled: true) }

  def in_stock? variant
    variant.sellable.unlimited_stock or (available_quantity_for(variant) > 0)
  end

  def available? variant, quantity
    variant.sellable.unlimited_stock or (available_quantity_for(variant) >= quantity)
  end

  def available_quantity_for variant
    available_quantities[variant.id] ||=
      variant.stocks.find { |stock| stock.store_id == self.id }.try(:count) || 0
  end

  private

  def available_quantities
    @available_quantities ||= {}
  end
end
