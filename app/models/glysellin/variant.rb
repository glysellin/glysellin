require 'friendly_id'

module Glysellin
  class Variant < ActiveRecord::Base
    self.table_name = 'glysellin_variants'

    extend FriendlyId
    friendly_id :name, use: :slugged

    include Glysellin::Imageable # has_many :images, as: :imageable

    belongs_to :sellable, class_name: "Glysellin::Sellable",
      inverse_of: :variants, counter_cache: true

    has_many :variant_properties, dependent: :destroy, inverse_of: :variant
    accepts_nested_attributes_for :variant_properties, allow_destroy: true

    has_many :properties, through: :variant_properties

    has_many :stocks, dependent: :destroy
    has_many :stores, through: :stocks
    accepts_nested_attributes_for :stocks, allow_destroy: true

    has_many :line_items

    # validate :check_properties
    validate :generate_barcode, on: :create, unless: :"sku.presence"
    validates_length_of :sku, :minimum => 13, :maximum => 13

    scope :available, -> {
      where(published: true).where(
        "glysellin_variants.unlimited_stock = ? OR " +
        "glysellin_variants.in_stock > ?",
        true, 0
      )
    }

    scope :published, -> { where(published: true) }

    delegate :eot_price, :price, :vat_rate, :vat_ratio, :weight, to: :sellable

    # def check_properties
    #   errors.add(:missing_property, 'Merci de renseigner un genre !') unless properties_hash['gender']
    #   errors.add(:missing_property, 'Merci de renseigner une collection !') unless properties_hash['collection']
    # end

    def name
      properties_names = variant_properties.map do |variant_property|
        variant_property.property.value
      end.join(', ')

      [sellable.name, properties_names].join(" - ")
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
      sellable ? sellable.description : ""
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

    def marked_down?
      (p = unmarked_price.presence) && p != price
    end
  end
end
