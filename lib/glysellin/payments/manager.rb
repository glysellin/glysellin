module Glysellin
  module Payments
    class Manager
      attr_accessor :order

      state_machine initial: :pending do
        event :empty do
          transition all => :pending
        end

        event :completed do
          transition all => :complete
        end

        event :partially_paid do
          transition all => :unbalanced
        end

        event :over_paid do
          transition all => :over_paid
        end

        after_transition on: :completed do |manager|
          manager.order.execute_sold_callbacks
        end
      end

      delegate :payments, to: :order

      def initialize order
        @order = order
        self.class.state_machines.initialize_states(self)
      end

      def state
        order.payment_state
      end

      def state=(val)
        order.payment_state = val
      end

      def save
        process_payments
      end

      def process_payments
        if payments.balanced? && !complete?
          completed
        elsif payments.unpaid? && !pending?
          empty
        elsif payments.partially_paid? && !unbalanced?
          partially_paid
        elsif payments.over_paid? && !over_paid?
          over_paid
        end
      end

      # Callback invoked after event :paid
      def set_payment
        payment.pay!
        update_attribute(:paid_on, payment.last_payment_action_on)
      end
    end
  end
end