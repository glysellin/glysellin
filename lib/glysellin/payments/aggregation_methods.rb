module Glysellin
  module Payments
    module AggregationMethods
      def total
        reduce(0) do |sum, payment|
          amount = payment.marked_for_destruction? ? 0 : payment.amount
          sum + amount
        end
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
        remaining > 0 && total != 0
      end

      def unpaid?
        total == 0
      end
    end
  end
end
