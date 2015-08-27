module Glysellin
  module Sellable
    module Mixin
      extend ActiveSupport::Concern

      included do
        include Glysellin::Sellable::PriceAutocompletion
        include Glysellin::Sellable::VatRate
        include Glysellin::Sellable::Stocks

        has_many :line_items, class_name: 'Glysellin::LineItem'

        validates :name, presence: true
        validates :eot_price, :price, :vat_rate, numericality: true
      end

      def to_line_item
        raise NotImplementedError,
             'Please define the #to_line_item in your sellable class'
      end
    end
  end
end
