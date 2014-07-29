module Glysellin
  class DiscountCode < ActiveRecord::Base
    self.table_name = 'glysellin_discount_codes'

    scope :from_code, -> (code) { where(code: code.try(:downcase)) }

    belongs_to :discount_type, inverse_of: :discount_codes
    has_many :order_adjustments, as: :adjustment

    validates_presence_of :name, :code, :discount_type, :value

    def code=(val)
      super(val && val.downcase)
    end

    def applicable_for?(price)
      (!expires_on || expires_on > Time.now) &&
        (!order_minimum.presence || order_minimum <= price)
    end
  end
end
