module Glysellin
  class PaymentMethodSerializer < ActiveModel::Serializer
    attributes :id, :name, :identifier
  end
end
