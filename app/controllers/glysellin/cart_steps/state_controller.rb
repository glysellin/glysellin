module Glysellin
  module CartSteps
    class StateController < CartController
      def show
        state = params[:state]

        if current_cart.available_states.include?(state)
          if current_cart.order
            current_cart.cancel_order!
          end

          current_cart.update_attributes(state: state)
        end

        redirect_to cart_path
      end
    end
  end
end
