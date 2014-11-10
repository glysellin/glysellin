require 'friendly_id'

module Glysellin
  class Variant < ActiveRecord::Base
    self.table_name = 'glysellin_variants'

    extend FriendlyId
    friendly_id :name, use: :slugged

    has_many :imageables, as: :imageable_owner, dependent: :destroy
    accepts_nested_attributes_for :imageables, allow_destroy: true

    has_many :images, through: :imageables

    belongs_to :sellable, class_name: "Glysellin::Sellable",
      inverse_of: :variants, counter_cache: true

    has_many :variant_properties, dependent: :destroy, inverse_of: :variant
    accepts_nested_attributes_for :variant_properties, allow_destroy: true

    has_many :customer_types_variants, dependent: :destroy, class_name: 'Glysellin::CustomerTypesVariant'
    accepts_nested_attributes_for :customer_types_variants, allow_destroy: true

    has_many :properties, through: :variant_properties

    has_many :stocks, dependent: :destroy
    has_many :stores, through: :stocks
    accepts_nested_attributes_for :stocks, allow_destroy: true

    has_many :line_items

    # validate :check_properties
    before_validation :check_prices
    before_validation :ensure_name
    before_validation :refresh_long_name

    validate :generate_barcode, on: :create, unless: Proc.new { |variant| variant.sku.present? }
    # validates_numericality_of :eot_price, :price
    validates :name, presence: true

    scope :published, -> { where(published: true) }

    delegate :vat_rate, :vat_ratio, :weight, to: :sellable

    def eot_price_for(customer_type)
      return eot_price unless customer_type.present?

      customer_type_id = if customer_type.is_a?(Glysellin::CustomerType)
        customer_type.id
      else
        customer_type.to_i
      end

      variant_price = customer_types_variants.find do |customer_types_variant|
        customer_types_variant.customer_type_id == customer_type_id
      end

      if variant_price
        variant_price.eot_price
      else
        eot_price
      end
    end

    def price_for(customer_type)
      return eot_price unless customer_type.present?

      (eot_price_for(customer_type) * vat_ratio).round(2)
    end

    def ensure_name
      return if name.presence || variant_properties.length == 0
      self.name = custom_name
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

    def price
      read_attribute(:price) || (sellable && sellable.price)
    end

    def eot_price
      read_attribute(:eot_price) || (sellable && sellable.eot_price)
    end

    def custom_name
      if variant_properties.any?
        properties_names = variant_properties.map(&:property).flatten.map(&:value).join(', ')
        [sellable.name, properties_names].join(' — ')
      else
        [sellable.name, name].join(' — ')
      end
    end

    def refresh_long_name
      taxonomy_parts = sellable.taxonomy.path[1..-1].map(&:name).flatten

      properties = variant_properties.map(&:property)
      properties_parts = if properties.length > 0
        properties.map(&:value).join(', ').presence
      end

      parts = [*taxonomy_parts, sellable.name, properties_parts]
      self.long_name = parts.compact.join(' - ')
    end

    def properties_hash
      @properties_hash ||= begin
        properties = Glysellin::Property
          .includes(:property_type)
          .where(id: variant_properties.map(&:property_id))

        properties.reduce({}) do |hash, property|
          hash[property.property_type.identifier] = property
          hash
        end
      end
    end

    def description
      sellable ? sellable.description : ''
    end

    def stocks_for_all_stores
      @stocks_for_all_stores ||=
        Glysellin::Store.all.each_with_object({}) do |store, hash|
          existing_stock = stocks.find { |stock| stock.store_id == store.id }
          hash[store] = existing_stock || stocks.build(store: store)
        end
    end

    def generate_barcode
      barcode = Glysellin.barcode_class_name.constantize.new(self)

      if barcode.valid?
        self.sku = barcode.generate
      else
        for message in barcode.errors.full_messages
          errors.add :sku, message
        end
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
      Glysellin.default_vat_rate
    end

    def vat_ratio
      1 + vat_rate / 100
    end
  end
end
