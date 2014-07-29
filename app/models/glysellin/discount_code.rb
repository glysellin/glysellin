module Glysellin
  class DiscountCode < ActiveRecord::Base
    self.table_name = 'glysellin_discount_codes'

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

    class << self
      def from_code code
        code && find_by_code(code.downcase)
      end
    end
  end
end
