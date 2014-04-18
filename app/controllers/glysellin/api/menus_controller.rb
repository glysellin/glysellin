module Glysellin
  module Api
    class MenusController < BaseController
      def index
        @taxonomies = Glysellin::Taxonomy.order('name desc').first.descendants(at_depth: 1)
        render json: @taxonomies, each_serializer: Glysellin::TaxonomySerializer
      end
    end
  end
end
