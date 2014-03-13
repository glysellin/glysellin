require 'friendly_id'

module Glysellin
  class Variant < ActiveRecord::Base
    extend FriendlyId

    friendly_id :name, use: :slugged

    self.table_name = 'glysellin_variants'

    belongs_to :sellable, class_name: "Glysellin::Sellable"

    has_many :variant_properties, class_name: 'Glysellin::VariantProperty', dependent: :destroy, inverse_of: :variant
    has_many :properties, class_name: 'Glysellin::Property', through: :variant_properties
    accepts_nested_attributes_for :variant_properties, allow_destroy: true

    has_many :stocks, class_name: 'Glysellin::Stock', dependent: :destroy
    has_many :stores, class_name: 'Glysellin::Variant', through: :stocks
    accepts_nested_attributes_for :stocks, allow_destroy: true

    validates_presence_of :name
    validates_presence_of :price
    validates_numericality_of :price

    after_create :generate_barcode
    before_validation :check_prices
    validate :check_properties, on: :create
    validate :check_properties, on: :update

    # after_initialize :prepare_properties

    AVAILABLE_QUERY = <<-SQL
      glysellin_variants.published = ? AND (
        glysellin_variants.unlimited_stock = ? OR
        glysellin_variants.in_stock > ?
      )
    SQL

    scope :available, -> { where(AVAILABLE_QUERY, true, true, 0) }
    scope :published, -> { where(published: true) }

    delegate :vat_rate, :vat_ratio, to: :sellable

    def check_properties
      errors.add(:missing_property, 'Merci de renseigner un motif !') unless properties_hash['gender']
      errors.add(:missing_property, 'Merci de renseigner un motif !') unless properties_hash['collection']
    end

    def properties_hash
      @properties_hash ||= begin
        properties = Glysellin::Property.includes(:property_type).where(id: variant_properties.map(&:property_id))

        properties.reduce({}) do |hash, property|
          hash[property.property_type.identifier] = property
          hash
        end
      end
    end

    def check_prices
      return unless price.present? && eot_price.present?
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

    def stocks_for_all_stores
      @stocks_for_all_stores ||= Glysellin::Store.all.map do |store|
        stores_stocks[store] ||= stocks.build(store: store)
      end
    end

    def stores_stocks
      @stores_stocks ||= stocks.reduce({}) do |hash, stock|
        hash[stock.store] = stock
        hash
      end
    end

    def generate_barcode
      barcode = Glysellin.barcode_class_name.constantize.new(self).generate
      self.update_column(:sku, barcode)
    end

    def marked_down?
      (p = unmarked_price.presence) && p != price
    end
  end
end