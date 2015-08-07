module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer

    self.table_name = 'glysellin_customers'

    acts_as_taggable_on :groups

    has_many :orders, class_name: 'Glysellin::Order', foreign_key: :customer_id

    belongs_to :customer_type, class_name: 'Glysellin::CustomerType'

    belongs_to :user, class_name: 'User', inverse_of: :customer
    accepts_nested_attributes_for :user

    def name
      [full_name, company_name].map(&:presence).compact.join(' - ')
    end

    def full_name
      [first_name, last_name].map(&:presence).compact.join(' ')
    end

    def password_filled_in?
      user.password.present?
    end
  end
end
