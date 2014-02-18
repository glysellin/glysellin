require 'friendly_id'

module Glysellin
  class Sellable < ActiveRecord::Base

    self.table_name = 'glysellin_sellables'

    cattr_accessor :sold_callback

    belongs_to :sellable, polymorphic: true, inverse_of: :product
    belongs_to :brand, class_name: "Glysellin::Brand", inverse_of: :products

    validates_numericality_of :vat_rate

    has_many :variants, class_name: "Glysellin::Variant", inverse_of: :sellable,
      dependent: :destroy
    accepts_nested_attributes_for :variants, allow_destroy: true,
      reject_if: :all_blank

    # Published sellables are the ones that have at least one variant
    # published.
    #
    # This behaviour can be overriden inside the sellable's model if the
    # scope is declared after the `acts_as_sellable` call
    scope :published, -> {
      includes(:variants).where(glysellin_variants: { published: true })
    }

    def published_variants
      variants.published
    end

    def vat_rate
      read_attribute(:vat_rate).presence || Glysellin.default_vat_rate
    end

    def vat_ratio
      1 + vat_rate / 100
    end
  end
end
