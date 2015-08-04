module Glysellin
  module CartSteps
    class ShippingMethodController < CartController
      def update
        current_cart.build_shipment unless current_cart.shipment
        current_cart.shipment.state = :pending

        if current_cart.update_attributes!(cart_params)
          current_cart.calculate_shipment_price
          current_cart.shipping_method_chosen!
          redirect_to cart_path
        else
          current_cart.state = 'choose_shipping_method'
          render 'glysellin/cart/show'
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
