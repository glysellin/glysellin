require 'friendly_id'

module Glysellin
  class Sellable < ActiveRecord::Base
    self.table_name = 'glysellin_sellables'

    cattr_accessor :sold_callback

    belongs_to :taxonomy, class_name: "Glysellin::Taxonomy"
    belongs_to :brand, class_name: "Glysellin::Brand", inverse_of: :products

    validates_presence_of :name, :vat_rate, :eot_price, :price, :taxonomy_id

    validates_numericality_of :vat_rate, :eot_price, :price

    has_many :variants, class_name: "Glysellin::Variant", inverse_of: :sellable,
      dependent: :destroy
    accepts_nested_attributes_for :variants, allow_destroy: true

    validates :variants, length: {
      minimum: 1, too_short: I18n.t("glysellin.errors.variants.too_short")
    }

    before_validation :check_prices

    # Published sellables are the ones that have at least one variant
    # published.
    #
    # This behaviour can be overriden inside the sellable's model if the
    # scope is declared after the `acts_as_sellable` call
    #
    scope :published, -> {
      includes(:variants).where(glysellin_variants: { published: true })
    }

    def published_variants
      variants.published
    end

    def check_prices
      return unless price.present? && eot_price.present?
      # If we have to fill one of the prices when changed
      if eot_changed_alone?
        self.price = (eot_price * vat_ratio).round(2)
      elsif price_changed_alone?
        self.eot_price = (price / vat_ratio).round(2)
      end
    end

    def eot_changed_alone?
      eot_changed_alone = eot_price_changed? && !price_changed?
      new_record_eot_alone = new_record? && eot_price && !price

      eot_changed_alone || new_record_eot_alone
    end

    def price_changed_alone?
      price_changed? || (new_record? && price)
    end

    def vat_rate
      read_attribute(:vat_rate).presence || Glysellin.default_vat_rate
    end

    def vat_ratio
      1 + vat_rate / 100
    end
  end
end
