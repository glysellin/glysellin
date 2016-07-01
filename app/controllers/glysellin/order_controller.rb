module Glysellin
  class OrderController < CartController
    def show
      unless (@order = current_cart.order)
        flash[:alert] = t('glysellin.controllers.errors.order_doesnt_exist')
        redirect_to root_path
      end
    end
  end
end
