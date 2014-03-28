module Glysellin
  module Api
    class SellablesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @q = Glysellin::Sellable.search(params[:q])
        render json: @q.result, each_serializer: Glysellin::SellableSerializer
      end
    end
  end
end
