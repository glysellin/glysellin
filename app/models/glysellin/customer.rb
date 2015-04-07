module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer

    self.table_name = 'glysellin_customers'

    acts_as_taggable_on :groups

    validates :first_name, :last_name, presence: true,
              unless: :company_name_filled_in?

    has_many :orders, class_name: 'Glysellin::Order', foreign_key: :customer_id

    belongs_to :customer_type, class_name: 'Glysellin::CustomerType'

    belongs_to :user, class_name: 'User', inverse_of: :customer
    accepts_nested_attributes_for :user, reject_if: :all_blank

    def update_from_cart! cart
      update! email: user.email
      update! billing_address: cart.billing_address.dup
      update! shipping_address: cart.shipping_address.dup
    end

    def name
      [full_name, company_name].map(&:presence).compact.join(' - ')
    end

    def full_name
      [first_name, last_name].map(&:presence).compact.join(' ')
    end

    def password_filled_in?
      user.password.present?
    end

    def company_name_filled_in?
      company_name.present?
    end
  end
end
