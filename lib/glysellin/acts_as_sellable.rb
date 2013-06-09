module Glysellin
  module ActsAsSellable
    extend ActiveSupport::Concern

    module ClassMethods

      # Macro to include sellable behaviour in side any model
      #
      def acts_as_sellable options = {}
        define_sellable_associations!
        define_sellable_product_filters!
      end

      private

      # Defines the polymorphic has_one association with the Glysellin::Product
      # model
      #
      def define_sellable_associations!
        has_one :product, as: :sellable, class_name: "Glysellin::Product",
          inverse_of: :sellable
        accepts_nested_attributes_for :product, :allow_destroy => true
        attr_accessible :product_attributes
      end


      def define_sellable_product_filters!
        if find_attribute(:name)
          before_save :fill_product_name_from_sellable
        end
      end

      # Finds a column matching any of the given names
      #
      def find_attribute *attributes
        @instance ||= new
        attributes.find { |attribute| @instance.respond_to?(attribute) }
      end
    end

    # Filter to proxy sellable model name attribute to product one
    #
    def fill_product_name_from_sellable
      product && product.name = name
    end
  end
end