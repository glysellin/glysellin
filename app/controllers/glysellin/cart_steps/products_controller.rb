module Glysellin
  module CartSteps
    class ProductsController < CartController
      def create
        @line_item = current_cart.line_items.build(line_item_params)

        if (variant = Glysellin::Variant.where(id: line_item_params[:variant_id]).first)
          @line_item.autofill_from(variant)
        end

        current_cart.line_items_added!
        render_cart_partial
      end

      def update
        current_cart.update_attributes(cart_params)

        line_item = current_cart.line_item(params[:id])

        render json: {
          quantity: line_item.quantity,
          eot_price: number_to_currency(line_item.total_eot_price),
          price: number_to_currency(line_item.total_price)
        }.merge(totals_hash)
      end

      def destroy
        current_cart.remove_line_item(params[:id])
        redirect_to cart_path
      end

      def validate
        current_cart.update_attributes(cart_params)
        current_cart.customer = current_user.customer if user_signed_in?
        current_cart.validated! if current_cart.valid?
        redirect_to cart_path
      end

      private

      def cart_params
        params.require(:cart).permit(
          :discount_code,
          line_items_attributes: [:id, :variant_id, :quantity, :_destroy]
        )
      end

      def line_item_params
        params.require(:line_item).permit(:variant_id, :quantity)
      end
    end
  end
end