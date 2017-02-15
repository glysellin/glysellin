module Glysellin
  module OrdersHelper

    # Generates Orderer form fields
    #
    # @param form Form object to which the fields are added
    # @param record Optional model object that implements Glysellin::Orderer
    #
    def addresses_fields_for form, record = nil
      # Copy addresses from record to form object

      if record && record.use_another_address_for_shipping && !form.object.billing_address
        form.object.use_another_address_for_shipping = true
      end

      %w(billing_address shipping_address).each do |type|
        copy_address_to(form.object, type, record)
      end

      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end

    def copy_address_to(orderer, type, record)
      return if orderer.send(type)

      if record && (address = record.send("#{ type }"))
        orderer.send(:"#{ type }=", address.dup)
      else
        orderer.send(:"build_#{ type }")
      end
    end

    # Deprecated, here for backwards compatibility
    def copy_address_to_form(form, type, record)
      copy_address_to(form.object, type, record)
    end

    def render_payment_button_for(order)
      data = {
        :'payment-request-expires-at' => 15.minutes.from_now.to_i,
        :'payment-request-expired-url' => url_for(payment_request_expired: true)
      }

      content_tag(:div, class: 'payment-request-button', data: data) do
        (render order.payments.last.payment_method.request_button(order)).html_safe
      end
    end
  end
end
