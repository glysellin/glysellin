class Glysellin::Store < ActiveRecord::Base
  self.table_name = "glysellin_stores"

  has_many :stocks, dependent: :destroy
  has_many :variants, through: :stocks

  has_many :orders, dependent: :nullify

  validates :name, presence: true
end
