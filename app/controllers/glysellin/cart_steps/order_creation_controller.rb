module Glysellin
  module CartSteps
    class OrderCreationController < CartController
      def update
        if params[:cart] && current_cart.update_attributes(cart_params)
          current_cart.create_order!
          OrderCustomerMailer.send_order_created_email(current_cart.order).deliver

          session['glysellin.order'] = current_cart.order.id
          current_cart.reload.destroy

          redirect_to order_path
        else
          if !params[:cart]
            flash[:error] = t('glysellin.errors.cart.state_transitions.recap')
          end

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
    end
  end
end
