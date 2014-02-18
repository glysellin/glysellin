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
        # Attributes delegation. Allowing to consider Product as a simple
        # configuration model for the sellable one.
        #
        delegate :vat_rate, :vat_ratio, to: :product

        # delegate :price, :unmarked_price, :marked_down?, to: :master_variant
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