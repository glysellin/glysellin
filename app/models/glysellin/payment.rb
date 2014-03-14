module Glysellin
  class Payment < ActiveRecord::Base
    self.table_name = 'glysellin_payments'

    belongs_to :order, inverse_of: :payments

    belongs_to :payment_method, class_name: 'PaymentMethod',
      inverse_of: :payments

    PAYMENT_STATUS_PENDING = 'pending'
    PAYMENT_STATUS_PAID = 'paid'
    PAYMENT_STATUS_CANCELED = 'canceled'

    def new_status s
      self.status = s
      self.last_payment_action_on = Time.now
      self.save
    end

    def new_transaction_id!
      last_transaction_with_id = self.class.where('transaction_id > 0').order('transaction_id DESC').first
      next_id = last_transaction_with_id ? last_transaction_with_id.transaction_id + 1 : 1
      update_column!("transaction_id", next_id)
    end

    def get_new_transaction_id
      new_transaction_id!
      transaction_id
    end

    def status_enum
      [
        PAYMENT_STATUS_PAID, PAYMENT_STATUS_PENDING, PAYMENT_STATUS_CANCELED
      ].map do |s|
        [I18n.t("glysellin.labels.payments.statuses.#{ s }"), s]
      end
    end

    def by_check?
      type.slug == 'check'
    end
  end
end
