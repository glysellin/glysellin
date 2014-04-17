module Glysellin
  module Helpers
    module Controller
      extend ActiveSupport::Concern

      included do
        helper_method :current_cart
      end

      protected

      def current_cart
        @cart ||= Cart.fetch_or_initialize(
          id: session["glysellin.cart"], store: current_store
        )
      end

      def current_store
        @store ||= Store.where(
          id: StoreClient.select(:store_id).where(
            key: Glysellin.default_store_client_key
          )
        ).first
      end

      def reset_cart!
        current_cart.destroy
        @cart = Cart.new
        session.delete("glysellin.cart")
      end
    end
  end
end
