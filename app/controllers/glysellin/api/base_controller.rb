module Glysellin
  module Api
    class StoreNotFound < StandardError; end

    class BaseController < ApplicationController
      respond_to :json

      skip_before_filter :authenticate_admin_user!
      before_filter :authenticate_client!
      serialization_scope :client
      attr_reader :client

      private

      def authenticate_client!
        @client = Glysellin::StoreClient.where(key: params[:api_key]).first
        raise StoreNotFound unless @client
      end
    end
  end
end
