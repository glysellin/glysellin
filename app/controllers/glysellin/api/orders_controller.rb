module Glysellin
  module Api
    class OrdersController < ApplicationController
      respond_to :json
      skip_before_filter :authenticate_admin_user!

      def create
        @order = Glysellin::Order.new order_params

        if @order.save
          render json: @order
        else
          render json: { errors: @order.errors }, status: :unprocessable_entity
        end
      end

      private

      def order_params
        params.require(:order).permit!
      end
    end
  end
end