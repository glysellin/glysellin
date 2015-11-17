module Glysellin
  module CartSteps
    class DiscountCodesController < CartController
      def update
        current_cart.add_discount_code! params[:code]
        render json: totals_hash
      end
    end
  end
end
