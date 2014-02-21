class Glysellin::Store < ActiveRecord::Base
  self.table_name = "glysellin_stores"

  has_many :stocks, class_name: 'Glysellin::Stock', dependent: :destroy
  has_many :variants, class_name: 'Glysellin::Variant', through: :stocks

  validates :name, presence: true
end
