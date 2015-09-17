module Glysellin
  module Orderer
    extend ActiveSupport::Concern

    included do
      has_one :billing_address, class_name: 'Glysellin::Address',
        as: :billed_addressable, dependent: :destroy

      has_one :shipping_address, class_name: 'Glysellin::Address',
        as: :shipped_addressable, dependent: :destroy

      accepts_nested_attributes_for :billing_address
      accepts_nested_attributes_for :shipping_address,
        reject_if: :shipping_address_blank_or_not_needed

      alias_method :actual_shipping_address, :shipping_address

      define_method(:shipping_address) do |force_reload = false|
        if use_another_address_for_shipping
          actual_shipping_address(force_reload)
        else
          billing_address(force_reload)
        end
      end
    end

    def has_shipping_address?
      shipping_address && shipping_address.id.present?
    end

    private

    def shipping_address_blank_or_not_needed(attributes)
      attributes.values.all?(&:blank?) || !use_another_address_for_shipping
    end
  end

  module ActsAsOrderer
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_orderer
        include Orderer
      end
    end
  end
end
