module Glysellin
  module Api
    class TaxonomiesController < BaseController
      def index
        @taxonomies = Glysellin::Taxonomy.roots
        render json: @taxonomies, each_serializer: Glysellin::ShallowTaxonomySerializer
      end

      def show
        @taxanomy = Glysellin::Taxonomy.includes(children: [children: :parent]).where(id: params[:id]).first
        render json: @taxanomy, each_serializer: Glysellin::TaxonomySerializer
      end
    end
  end
end
