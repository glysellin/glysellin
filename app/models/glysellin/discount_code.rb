module Glysellin
  class DiscountCode < ActiveRecord::Base
    include Adjustment

    self.table_name = 'glysellin_discount_codes'

    belongs_to :discount_type, inverse_of: :discount_codes
    has_many :order_adjustments, as: :adjustment

    validates_presence_of :name, :code, :discount_type, :value

    def code=(val)
      super(val && val.downcase)
    end

    def applicable?
      !expires_on || expires_on > Time.now
    end

    class << self
      def from_code code
        find_by_code(code.downcase)
      end
    end

    private

    def adjustment_value_for order
      calculator = Glysellin.discount_type_calculators[discount_type.identifier]
      calculator.new(order, value).calculate
    end
  end
end
