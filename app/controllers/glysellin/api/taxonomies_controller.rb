module Glysellin
  module Api
    class TaxonomiesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @taxonomies = Glysellin::Taxonomy.roots
        render json: @taxonomies, each_serializer: Glysellin::ShallowTaxonomySerializer
      end

      def show
        @taxanomy = Glysellin::Taxonomy.find params[:id]
        render json: @taxanomy, each_serializer: Glysellin::TaxonomySerializer
      end
    end
  end
end
