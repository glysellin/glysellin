module Glysellin
  class OrdersController < ApplicationController
    protect_from_forgery :except => :gateway_response
    def index
      @orders = Order.from_customer(current_user)
    end

    def show
      user_order = if user_signed_in?
        Order.where('id = ? AND customer_id = ?', params[:id], current_user.id)
      else
        []
      end

      if user_order.length > 0
        @order = user_order.first
      else
        flash[:alert] = t('glysellin.controllers.errors.order_doesnt_exist')
        redirect_to :action => 'index'
      end
    end

    def gateway_response
      # Get gateway object
      gateway = if params[:id]
        PaymentMethod.gateway_from_order_ref(params[:id])
      else
        PaymentMethod.gateway_from_raw_post(params[:gateway], request.raw_post)
      end
      # Process payment
      if gateway.process_payment! request.raw_post
        OrderCustomerMailer.send_order_paid_email(gateway.order).deliver
        OrderAdminMailer.send_order_paid_email(gateway.order).deliver
      end
      # Log errors if existing
      gateway.errors.each do |msg|
        logger.error "[ Glysellin ] Gateway Error : #{ msg }"
      end if gateway.errors.length > 1

      render gateway.response
    end

    def payment_response
      if params[:type]
        @order = nil
        @response_type = params[:type]

        # We remove cart from session if the order is considered as paid
        # by the return code.
        #
        # We cannot be 100% sure that this is a true "paid" request from the
        # bank, but this does not affect the actual order state, since we just
        # remove the cart from session
        #
        reset_cart! if @response_type == 'paid' || @order.paid?
      else
        @order = Order.find_by_ref(params[:id])
      end
    end
  end
end
