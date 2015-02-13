module Glysellin
  class OrderController < ApplicationController
    def show
      order_id = session['glysellin.order'].presence

      unless order_id && (@order = Order.where(id: order_id).first)
        flash[:alert] = t('glysellin.controllers.errors.order_doesnt_exist')
        redirect_to root_path
      end
    end
  end
end
