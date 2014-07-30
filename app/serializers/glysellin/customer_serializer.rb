module Glysellin
  class CustomerSerializer < ActiveModel::Serializer
    attributes :id, :full_name, :use_another_address_for_shipping
    has_one :billing_address, embed: :ids
    has_one :shipping_address, embed: :ids
  end
end
