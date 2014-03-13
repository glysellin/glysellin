module Glysellin
  class DiscountType < ActiveRecord::Base
    self.table_name = 'glysellin_discount_types'

    has_many :discount_codes, class_name: "Glysellin::DiscountCode",
      inverse_of: :discount_type

    has_many :discounts, class_name: "Glysellin::Discount",
      inverse_of: :discount_type
  end
end
