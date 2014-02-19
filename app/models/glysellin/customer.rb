module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer
    self.table_name = 'glysellin_customers'

    validates_presence_of :first_name, :last_name, unless: 'corporate_filled_in?'
    validates_presence_of :email
    validates_uniqueness_of :email

    has_one :user, class_name: Glysellin.user_class_name
    accepts_nested_attributes_for :user, reject_if: :all_blank

    def full_name
      [first_name, last_name].join(' ')
    end

    def password_filled_in?
      user.password.present?
    end

    def corporate_filled_in?
      corporate.present?
    end
  end
end
