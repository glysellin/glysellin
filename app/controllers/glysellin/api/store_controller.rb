module Glysellin
  module Api
    class StoreController < BaseController
      def show
        render json: client.store
      end
    end
  end
end
