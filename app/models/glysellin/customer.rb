module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer
    self.table_name = 'glysellin_customers'

    validates_presence_of :first_name, :last_name, unless: 'corporate_filled_in?'
    validates_presence_of :email, if: 'user.present?'
    validates_uniqueness_of :email, if: 'email.present?'

    has_one :user, class_name: Glysellin.user_class_name
    accepts_nested_attributes_for :user, reject_if: :all_blank

    before_validation :setup_user_email

    def full_name
      return unless first_name.present? && last_name.present?
      [first_name, last_name].join(' ')
    end

    def password_filled_in?
      user.password.present?
    end

    def corporate_filled_in?
      corporate.present?
    end

    private
    def setup_user_email
      return unless user.present?
      user.email = email
    end
  end
end
