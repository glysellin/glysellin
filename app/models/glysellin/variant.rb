require 'friendly_id'

module Glysellin
  class Variant < ActiveRecord::Base
    extend FriendlyId

    friendly_id :name, use: :slugged

    self.table_name = 'glysellin_variants'

    belongs_to :sellable, class_name: "Glysellin::Sellable"

    has_many :properties, class_name: 'Glysellin::ProductProperty',
      extend: Glysellin::PropertyFinder, dependent: :destroy,
      inverse_of: :variant

    accepts_nested_attributes_for :properties, allow_destroy: true

    validates_presence_of :name
    validates_numericality_of :price
    validates_numericality_of :in_stock, if: proc { |v| v.in_stock.presence }

    before_validation :check_prices

    # after_initialize :prepare_properties

    AVAILABLE_QUERY = <<-SQL
      glysellin_variants.published = ? AND (
        glysellin_variants.unlimited_stock = ? OR
        glysellin_variants.in_stock > ?
      )
    SQL

    scope :available, -> { where(AVAILABLE_QUERY, true, true, 0) }
    scope :published, -> { where(published: true) }

    # def prepare_properties
    #   if product && product.product_type
    #     product.product_type.property_types.each do |type|
    #       properties.build(type: type) if properties.send(type.name) == false
    #     end
    #   end
    # end

    delegate :vat_rate, :vat_ratio, to: :sellable

    def check_prices
      return unless sellable
      # If we have to fill one of the prices when changed
      if eot_changed_alone?
        self.price = (self.eot_price * vat_ratio).round(2)
      elsif price_changed_alone?
        self.eot_price = (self.price / vat_ratio).round(2)
      end
    end

    def eot_changed_alone?
      eot_changed_alone = self.eot_price_changed? && !self.price_changed?
      new_record_eot_alone = self.new_record? && self.eot_price && !self.price

      eot_changed_alone || new_record_eot_alone
    end

    def price_changed_alone?
      self.price_changed? || (self.new_record? && self.price)
    end

    def description
      sellable ? sellable.description : ""
    end

    def in_stock?
      unlimited_stock || in_stock > 0
    end

    def available_for quantity
      unlimited_stock || in_stock >= quantity
    end

    def name fullname = true
      variant_name, sellable_name = super().presence, (sellable && sellable.name)

      if fullname
        variant_name ? "#{ sellable_name } - #{ variant_name }" : sellable_name
      else
        variant_name ? variant_name : sellable_name
      end
    end

    def marked_down?
      (p = unmarked_price.presence) && p != price
    end
  end
end