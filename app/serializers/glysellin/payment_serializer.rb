module Glysellin
  class PaymentSerializer < ActiveModel::Serializer
    embed :ids

    attributes :id, :received_on, :amount

    has_one :payment_method, include: true
    has_one :order

    def order
      object.payable
    end
  end
end
