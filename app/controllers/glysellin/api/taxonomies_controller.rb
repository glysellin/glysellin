module Glysellin
  module Api
    class TaxonomiesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @q = Glysellin::Taxonomy.search(params)
        render json: @q.result, each_serializer: Glysellin::TaxonomySerializer
      end
    end
  end
end
