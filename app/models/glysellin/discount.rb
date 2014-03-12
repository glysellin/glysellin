module Glysellin
  class Discount < ActiveRecord::Base
    self.table_name = "glysellin_discounts"

    belongs_to :discountable, polymorphic: true
    belongs_to :discount_type

    validates_presence_of :value, :discount_type_id
  end
end
