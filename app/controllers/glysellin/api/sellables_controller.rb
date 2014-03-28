module Glysellin
  module Api
    class SellablesController < ApplicationController

      respond_to :json

      def index
        @q = Glysellin::Sellable.search(params[:q])
        respond_with @q.result
      end
    end
  end
end
