class Glysellin::Store < ActiveRecord::Base
  self.table_name = "glysellin_stores"

  has_many :stocks, dependent: :destroy
  has_many :variants, through: :stocks

  has_many :orders, dependent: :nullify

  validates :name, presence: true

  def in_stock? variant
    available_quantity_for(variant) > 0
  end

  def available? variant, quantity
    available_quantity_for(variant) > quantity
  end

  def available_quantity_for variant
    available_quantities[variant.id] ||=
      variant.stocks_for_all_stores[self].count
  end

  private

  def available_quantities
    @available_quantities ||= {}
  end
end
