module Glysellin
  module CartSteps
    class PaymentMethodController < CartController
      def update
        if current_cart.update_attributes(cart_params)
          current_cart.payment_method_chosen!
          OrderCustomerMailer.send_order_created_email(current_cart.order).deliver
          redirect_to cart_path
        else
          current_cart.state = "choose_payment_method"
          render "glysellin/cart/show"
        end
      end

      private

      def cart_params
        params.require(:cart).permit(
          payments_attributes: [:id, :payment_method_id]
        )
      end
    end
  end
end
