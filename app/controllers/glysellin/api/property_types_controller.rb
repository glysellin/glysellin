module Glysellin
  module Api
    class PropertyTypesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @q = Glysellin::PropertyType.search(params)
        render json: @q.result, each_serializer: Glysellin::PropertyTypeSerializer
      end
    end
  end
end
