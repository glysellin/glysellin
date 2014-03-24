module Glysellin
  module OrderPaymentsMethods
    def total
      sum(:amount)
    end

    def remaining
      proxy_association.owner.total_price - total
    end

    def balanced?
      remaining == 0
    end

    def over_paid?
      remaining < 0
    end

    def partially_paid?
      remaining > 0
    end
  end
end
