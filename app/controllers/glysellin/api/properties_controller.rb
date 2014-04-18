module Glysellin
  module Api
    class PropertiesController < BaseController
      def index
        @q = Glysellin::Property.search(params)
        render json: @q.result, each_serializer: Glysellin::PropertySerializer
      end
    end
  end
end
