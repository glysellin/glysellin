module Glysellin
  class OrderSerializer < ActiveModel::Serializer
    embed :ids, include: true

    attributes :id, :comment, :use_another_address_for_shipping

    has_one :customer
    has_one :billing_address, root: :addresses
    has_one :shipping_address, root: :addresses
    has_many :line_items
    has_many :discounts
    has_one :shipment
    has_many :payments
  end
end