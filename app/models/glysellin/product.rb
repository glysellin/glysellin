require 'friendly_id'

module Glysellin
  class Product < ActiveRecord::Base

    self.table_name = 'glysellin_products'

    belongs_to :sellable, polymorphic: true, inverse_of: :product
    belongs_to :brand, class_name: "Glysellin::Brand", inverse_of: :products

    validates_numericality_of :vat_rate

    def name
      sellable && sellable.name
    end

    def vat_rate
      read_attribute(:vat_rate).presence || Glysellin.default_vat_rate
    end

    def vat_ratio
      1 + vat_rate / 100
    end

    def variants
      sellable.published_variants
    end
  end
end