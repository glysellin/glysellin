module Glysellin
  module CartHelper
    def add_to_cart_form sellable, options = {}
      # Default to remote form
      options[:remote] = true unless options[:remote] == false

      # Render actual form
      render partial: 'glysellin/products/add_to_cart', locals: {
        sellable: sellable, options: options
      }
    end

    def added_to_cart_warning
      render partial: 'glysellin/cart/added_to_cart_warning'
    end

    def render_cart
      render partial: "glysellin/cart/cart", locals: { cart: current_cart }
    end
  end
end
