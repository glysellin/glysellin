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
        if (cart_id = cookies.encrypted["glysellin.cart"])
          if (cart = Cart.fetch(id: cart_id))
            return cart
          else
            # Ensure we remove the unfetchable cart from cookies to clean up
            # unavailable carts and start with a fresh new cart then.
            remove_cart_from_cookies
          end
        end

        Cart.build(store: current_store)
      end

      def current_store
        @current_store ||= fetch_current_store
      end

      def reset_cart!
        current_cart.destroy
        @cart = Cart.new
        remove_cart_from_cookies
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

      def set_cart_in_cookies(cart)
        cookies.permanent.encrypted["glysellin.cart"] = cart.id
      end

      def remove_cart_from_cookies
        cookies.delete("glysellin.cart")
      end
    end
  end
end
