module Glysellin
  class DiscountType < ActiveRecord::Base
    self.table_name = 'glysellin_discount_types'

    has_many :discount_codes, inverse_of: :discount_type
  end
end
