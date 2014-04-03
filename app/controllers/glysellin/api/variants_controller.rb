module Glysellin
  module Api
    class VariantsController < ApplicationController
      respond_to :json
      skip_before_filter :authenticate_admin_user!

      def index
        @q = Glysellin::Variant.search(params)
        respond_with @q.result
      end
    end
  end
end
