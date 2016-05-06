module Glysellin
  module CartSteps
    class OrderCreationController < CartController
      def update
        if params[:cart] && current_cart.update_attributes(cart_params)
          current_cart.create_order!

          order = current_cart.order
          OrderCustomerMailer.send_order_created_email(order).deliver
          OrderAdminMailer.send_check_order_created_email(order).deliver if check?(order)

          session['glysellin.order'] = current_cart.order.id
          current_cart.reload.destroy

          redirect_to order_path
        else
          set_cart_errors_flash
          current_cart.state = "recap"
          render "glysellin/cart/show"
        end
      end

      private

      def cart_params
        if params.key?(:cart)
          params.require(:cart).permit(
            payments_attributes: [:id, :payment_method_id]
          )
        else
          {}
        end
      end

      def check?(order)
        Gateway::Check === PaymentMethod.gateway_for(order)
      end
    end
  end
end
