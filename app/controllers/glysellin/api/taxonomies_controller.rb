module Glysellin
  module Api
    class TaxonomiesController < BaseController
      def index
        @taxonomies = Glysellin::Taxonomy.roots
        render json: @taxonomies, each_serializer: Glysellin::ShallowTaxonomySerializer
      end

      def show
        @taxanomy = Glysellin::Taxonomy.includes(taxonomy_includes).where(id: params[:id]).first
        render json: @taxanomy, each_serializer: Glysellin::TaxonomySerializer
      end

      private

      def taxonomy_includes
        [sellables: sellable_includes, children: [sellables: sellable_includes, children: [:parent, sellables: sellable_includes, children: :parent]]]
      end

      def sellable_includes
        [:variant_images, variants: [:stocks, :variant_images, variant_properties: [property: :property_type]]]
      end
    end
  end
end
