module Glysellin
  class CartController < ApplicationController
    include ActionView::Helpers::NumberHelper

    before_filter :prepare_associable_data
    before_filter :handle_payment_request_expired
    after_filter :update_cart_in_cookies

    def show
    end

    def destroy
      reset_cart!
      redirect_to cart_path
    end

    protected

    def render_cart_partial
      render partial: 'cart', locals: { cart: current_cart }
    end

    # Helper method to set cookie value
    def update_cart_in_cookies
      set_cart_in_cookies(current_cart) if current_cart
    end

    def totals_hash
      if (discount = current_cart.discounts.first)
        discount_name = discount.name
        discount_value = number_to_currency(discount.price)
      end

      {
        discount_name: discount && discount_name,
        discount_value: discount && discount_value,
        total_eot_price: number_to_currency(current_cart.total_eot_price),
        total_price: number_to_currency(current_cart.total_price),
        eot_subtotal: number_to_currency(current_cart.eot_subtotal),
        subtotal: number_to_currency(current_cart.subtotal)
      }
    end

    def prepare_associable_data
      @shipping_methods = Glysellin::ShippingMethod.ordered
      @payment_methods = Glysellin::PaymentMethod.ordered
    end

    def set_cart_errors_flash
      flash[:error] = t(
        "glysellin.errors.cart.state_transitions.#{ current_cart.state }"
      ) if current_cart.errors.any?
    end

    def handle_payment_request_expired
      if params[:payment_request_expired] == 'true'
        flash.now[:error] = t('glysellin.errors.cart.payment_request_expired')
      end
    end
  end
end
