module Glysellin
  module CartSteps
    class AddressesController < CartController
      def update
        if user_signed_in?
          current_cart.update(customer: current_user.customer)

          # Set customer_attributes id to the current user's customer id to
          # avoid rails nested attributes setter to override the current cart's
          # user
          if (customer_params = params[:cart] && params[:cart][:customer_attributes])
            customer_params[:id] = current_user.customer.id
            customer_params.delete(:user_attributes)
          end
        end

        if current_cart.update_attributes(cart_params)
          current_cart.addresses_filled!

          if !user_signed_in? && Glysellin.sign_in_after_user_selection && current_cart.customer.user
            sign_in current_cart.customer.user
          end

          redirect_to cart_path
        else
          set_cart_errors_flash
          current_cart.state = "addresses"
          render "glysellin/cart/show"
        end
      end

      private

      def cart_params
        cart_params = params.require(:cart).permit(
          :use_another_address_for_shipping,
          customer_attributes: [
            :id, :email, user_attributes: [
              :id, :email, :password, :password_confirmation
            ]
          ],
          billing_address_attributes: address_params,
          shipping_address_attributes: address_params
        )

        assign_customer_names_params!(cart_params)
        assign_user_email_params!(cart_params)

        cart_params
      end

      def assign_customer_names_params!(cart_params)
        if cart_params[:customer_attributes] &&
          cart_params[:billing_address_attributes]

          [:first_name, :last_name].each do |attribute|
            cart_params[:customer_attributes][attribute] =
              cart_params[:billing_address_attributes][attribute]
          end
        end
      end

      def assign_user_email_params!(cart_params)
        if (customer_attributes = cart_params[:customer_attributes] ) &&
           (email = customer_attributes[:email]) &&
           (user_attributes = customer_attributes[:user_attributes])

          user_attributes[:email] = email
        end
      end

      def address_params
        [:id, :last_name, :first_name, :address, :zip, :city, :country, :tel]
      end
    end
  end
end
