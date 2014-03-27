module Glysellin
  class PaymentSerializer < ActiveModel::Serializer
    attributes :id, :received_on, :amount, :order_id

    has_one :payment_method, embed: :ids, include: true
  end
end
