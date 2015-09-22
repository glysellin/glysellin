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
  end
end
