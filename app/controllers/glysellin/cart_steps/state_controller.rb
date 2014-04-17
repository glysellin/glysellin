module Glysellin
  module CartSteps
    class StateController < CartController
      def show
        state = params[:state]

        if current_cart.available_events.include?(state)
          current_cart.public_send(:"#{ state }!")
        end

        redirect_to cart_path
      end
    end
  end
end
