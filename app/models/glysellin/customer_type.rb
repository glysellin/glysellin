class Glysellin::CustomerType < ActiveRecord::Base
  self.table_name = "glysellin_customer_types"

  has_many :customers, dependent: :nullify

  has_many :customer_types_variants, dependent: :destroy,
           class_name: 'Glysellin::CustomerTypesVariant',
           inverse_of: :customer_type

  scope :ordered, -> { order('glysellin_customer_types.name ASC') }

  validates :name, presence: true

  def default_vat_rate
    read_attribute(:default_vat_rate) || Glysellin.default_vat_rate
  end
end
