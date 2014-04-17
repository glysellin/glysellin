module Glysellin
  module CartSteps
    class ShippingMethodController < CartController
      def update
        if current_cart.update_attributes(cart_params)
          current_cart.shipping_method_chosen!
          redirect_to cart_path
        else
          current_cart.state = "choose_shipping_method"
          current_cart.valid?
          render "glysellin/cart_steps/show"
        end
      end

      private

      def cart_params
        params.require(:cart).permit(
          shipment_attributes: [:id, :shipping_method_id]
        )
      end
    end
  end
end
