require "glysellin/sellable/simple"
require "glysellin/sellable/multi"

module Glysellin
  module Sellable
    extend ActiveSupport::Concern

    module ClassMethods

      # Macro to include sellable behaviour in side any model
      #
      # @param [Hash] options An option hash to configure the mixin
      #
      # @option options [Symbol] :simple If set to true, sellable will only have
      #   one variant, a has_one relation is defined between sellable and the
      #   Variant model
      # @option options [Boolean] :stock If set to false, consider every itmes
      #   should have unlimited stock. Defaults to true
      #
      def acts_as_sellable options = {}
        # Merge options with defaults and store them for further use
        cattr_accessor :sellable_options
        self.sellable_options = options.reverse_merge(
          simple: false,
          stock: true
        )

        include (sellable_options[:simple] ? Simple : Multi)

        # Defines the polymorphic has_one association with the
        # Glysellin::Product model, holding product wide configurations
        has_one :product, as: :sellable, class_name: "Glysellin::Product",
          inverse_of: :sellable, dependent: :destroy
        accepts_nested_attributes_for :product, allow_destroy: true
        attr_accessible :product_attributes

        unless sellable_options[:stock]
          before_validation :ensure_unlimited_stock
        end

        # Attributes delegation. Allowing to consider Product as a simple
        # configuration model for the sellable one.
        #
        delegate :vat_rate, :vat_ratio, to: :product

        # delegate :price, :unmarked_price, :marked_down?, to: :master_variant
      end

      # Defines the polymophic has_many association with the Variant model,
      # allowing to set multiple variants on our sellable
      #
      def define_multi_variants_relation!
        self.variant_association_name = "variants"

        has_many :variants, as: :sellable, class_name: "Glysellin::Variant",
          inverse_of: :sellable, dependent: :destroy
      end
    end

    # If acts_as_sellable is called with the option `stock: false`, we admit
    # every variant must be unlimited stock, so admins never have to bother
    # filling in stock or selecting `unlimited_stock: true`
    #
    def ensure_unlimited_stock
      variants.each do |variant|
        variant.unlimited_stock = true
        variant.save unless variant.new_record?
      end
    end

    def published_variants
      variants.published
    end
  end
end