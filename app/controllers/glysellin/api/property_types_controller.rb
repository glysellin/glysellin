module Glysellin
  module Api
    class PropertyTypesController < ApplicationController
      def index
        @q = Glysellin::PropertyType.search(params)
        render json: @q.result, each_serializer: Glysellin::PropertyTypeSerializer
      end
    end
  end
end
