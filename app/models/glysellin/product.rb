require 'digest/sha1'
require 'friendly_id'

module Glysellin
  class Product < ActiveRecord::Base
    include ProductMethods

    self.table_name = 'glysellin_products'

    belongs_to :sellable, polymorphic: true

    # Products can belong to a brand
    belongs_to :brand, :inverse_of => :products

    belongs_to :product_type

    has_many :variants, class_name: 'Glysellin::Variant',
      before_add: :set_product_on_variant, dependent: :destroy

    accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank

    attr_accessible :name, :slug, :vat_rate, :brand, :published,
      :unlimited_stock, :brand_id, :variants_attributes, :variants,
      :product_type_id

    # Validations
    #
    validates_presence_of :name, :slug
    # Validates price related attributes only unless we have bundled products
    # so we can defer validations to them
    validates :vat_rate, presence: true,
      numericality: true

    # Callbacks
    #
    before_validation :ensure_variant

    scope :published, where('glysellin_products.published = ?', true)

    # Master variant methods delegation
    delegate :price, :unmarked_price, :marked_down?, to: :master_variant

    def vat_rate
      super || Glysellin.default_vat_rate
    end

    def ensure_variant
      variants.build(product: self) unless variants.length > 0
    end

    # Fetches all available variants for the current product
    #
    def available_variants
      variants.available
    end

    def image
      images.length > 0 ? images.first.image : nil
    end

    def master_variant
      self.variants.first
    end

    def set_product_on_variant variant
      variant.product = self
    end
  end
end