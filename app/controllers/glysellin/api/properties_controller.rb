module Glysellin
  module Api
    class PropertiesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @q = Glysellin::Property.search(params)
        render json: @q.result, each_serializer: Glysellin::PropertySerializer
      end
    end
  end
end
