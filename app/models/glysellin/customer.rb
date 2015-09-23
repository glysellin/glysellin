module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer

    self.table_name = 'glysellin_customers'

    acts_as_taggable_on :groups

    has_many :orders, class_name: 'Glysellin::Order', foreign_key: :customer_id

    belongs_to :customer_type, class_name: 'Glysellin::CustomerType'

    belongs_to :user, class_name: Glysellin.user_class_name, inverse_of: :customer
    accepts_nested_attributes_for :user

    before_validation :ensure_names

    def name
      name = [company_name, full_name].map(&:presence).compact.join(' - ')

      name.presence || email
    end

    def full_name
      [last_name, first_name].map(&:presence).compact.join(' ')
    end

    def password_filled_in?
      user.password.present?
    end

    private

    def ensure_names
      [:company_name, :first_name, :last_name].each do |field|
        unless self.send(field).present?
          self.send(:"#{ field }=", billing_address.try(field))
        end
      end
    end
  end
end
