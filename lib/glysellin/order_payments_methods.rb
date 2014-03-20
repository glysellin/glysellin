module Glysellin
  module OrderPaymentsMethods
    def total
      sum(:amount)
    end

    def remaining
      proxy_association.owner.total_price - total
    end
  end
end
