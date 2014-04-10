module Glysellin
  module Orderer
    extend ActiveSupport::Concern

    included do
      has_one :billing_address, class_name: 'Glysellin::Address',
        as: :billed_addressable, dependent: :destroy

      has_one :shipping_address, class_name: 'Glysellin::Address',
        as: :shipped_addressable, dependent: :destroy

      accepts_nested_attributes_for :billing_address, reject_if: :all_blank
      accepts_nested_attributes_for :shipping_address, reject_if: :all_blank
    end

    def has_shipping_address?
      shipping_address && shipping_address.id.present?
    end

    def shipping_address
      use_another_address_for_shipping ? super : billing_address
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