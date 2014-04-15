module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'

    belongs_to :order, inverse_of: :payments

    belongs_to :payment_method, class_name: 'PaymentMethod',
      inverse_of: :payments

    state_machine :state, initial: :pending, use_transactions: false do
      event :pay do
        transition all => :paid
      end

      event :cancel do
        transition all => :canceled
      end

      before_transition to: :paid, do: :set_payment_date
    end

    def set_payment_date
      self.received_on = Time.now
    end

    def new_transaction_id!
      last_transaction_with_id = self.class.where('transaction_id > 0').order('transaction_id DESC').first
      next_id = last_transaction_with_id ? last_transaction_with_id.transaction_id + 1 : 1
      update_column!("transaction_id", next_id)
      next_id
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
      @states ||= (state_paths.to_states + [:pending])
    end

    def by_check?
      type.slug == 'check'
    end
  end
end
