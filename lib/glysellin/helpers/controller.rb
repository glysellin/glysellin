module Glysellin
  module Helpers
    module Controller
      extend ActiveSupport::Concern

      included do
        helper_method :current_cart, :current_store
      end

      protected

      def current_cart
        @cart ||= fetch_or_initialize_cart
      end

      def fetch_or_initialize_cart
        cart_id = cookies["glysellin.cart"]

        Cart.fetch_or_initialize(id: cart_id, store: current_store).tap do |cart|
          set_cart_in_cookies(cart)
        end
      end

      def set_cart_in_cookies(cart)
        cookies.permanent["glysellin.cart"] = cart.id
      end

      def current_store
        @current_store ||= fetch_current_store
      end

      def reset_cart!
        current_cart.destroy
        @cart = Cart.new
        cookies.delete("glysellin.cart")
      end

      def fetch_current_store
        if Glysellin.multi_store
          Store.where(
            id: StoreClient.select(:store_id).where(
              key: Glysellin.default_store_client_key
            )
          ).first
        else
          Store.first
        end
      end
    end
  end
end
