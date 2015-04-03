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

      %w(billing_address shipping_address).each do |addr|
        next if form.object.send(addr)

        if record && (address = record.send("#{ addr }"))
          form.object.send(:"#{ addr }=", address.dup)
        else
          form.object.send(:"build_#{ addr }")
        end
      end

      render partial: 'glysellin/orders/addresses_fields', locals: { form: form }
    end
  end
end
