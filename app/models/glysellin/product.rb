require 'digest/sha1'
require 'friendly_id'

module Glysellin
  class Product < ActiveRecord::Base

    self.table_name = 'glysellin_products'

    belongs_to :sellable, polymorphic: true, inverse_of: :product

    # Products can belong to a brand
    belongs_to :brand, class_name: "Glysellin::Brand", inverse_of: :products

    attr_accessible :vat_rate, :brand, :brand_id

    validates :vat_rate, presence: true, numericality: true

    def name
      sellable && sellable.name
    end

    def vat_rate
      super.presence || Glysellin.default_vat_rate
    end

    def vat_ratio
      1 + vat_rate / 100
    end

    def variants
      sellable.published_variants
    end
  end
end