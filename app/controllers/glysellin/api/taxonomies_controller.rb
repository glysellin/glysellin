module Glysellin
  module Api
    class TaxonomiesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        if params[:menu].present?
          @taxonomies = Glysellin::Taxonomy.roots.order('name desc').first.descendants(at_depth: 1)
          render json: @taxonomies, each_serializer: Glysellin::TaxonomiesMenuSerializer
        else
          @q = Glysellin::Taxonomy.search(params)
          render json: @q.result, each_serializer: Glysellin::TaxonomySerializer
        end
      end
    end
  end
end
