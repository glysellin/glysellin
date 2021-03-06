module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'

    belongs_to :payable, polymorphic: true, inverse_of: :payments
    belongs_to :payment_method, class_name: 'PaymentMethod'

    validates :payable, presence: true

    state_machine :state, initial: :pending, use_transactions: false do
      event :reset do
        transition all => :pending
      end

      event :pay do
        transition all => :paid
      end

      event :cancel do
        transition all => :canceled
      end

      before_transition to: :paid, do: :set_payment_date
    end

    # On cart payments duplication, the state attribute is not saved.
    #
    # This may be a bug from the state_machines gem, but I couldn't find a
    # proper way to fix that.
    #
    # So we return a default pending state to avoid further transitions to fail,
    # which allows, for example, payment gateways notifications to work.
    #
    def state
      read_attribute(:state) || 'pending'
    end

    def set_payment_date
      self.received_on = Time.now
    end

    def last_transaction_id
      last_transaction = self.class.where('transaction_id > 0').order('transaction_id DESC').first
      last_transaction ? last_transaction.transaction_id : 0
    end

    def new_transaction_id!
      (last_transaction_id + 1).tap do |id|
        update_column("transaction_id", id)
      end
    end

    def get_new_transaction_id
      new_transaction_id!
    end

    def status_enum
      states.map do |state|
        [I18n.t("glysellin.labels.payments.statuses.#{ state }"), state]
      end
    end

    def states
      @states ||= state_paths.to_states
    end

    def by_check?
      payment_method.identifier == 'check'
    end
  end
end
