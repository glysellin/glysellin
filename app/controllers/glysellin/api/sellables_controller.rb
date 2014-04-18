module Glysellin
  module Api
    class SellablesController < ApplicationController
      skip_before_filter :authenticate_admin_user!

      def index
        @sellables = Glysellin::Sellable.all
        render json: @sellables, each_serializer: Glysellin::ShallowSellableSerializer
      end

      def show
        @sellable = Glysellin::Sellable.find params[:id]
        render json: @sellable, each_serializer: Glysellin::SellableSerializer
      end
    end
  end
end
