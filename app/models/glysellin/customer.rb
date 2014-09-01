module Glysellin
  class Customer < ActiveRecord::Base
    include Orderer

    self.table_name = 'glysellin_customers'

    acts_as_taggable_on :groups

    validates_presence_of :first_name, :last_name,
                          unless: :company_name_filled_in?

    validates_presence_of :email,   if: Proc.new { |customer| customer.user.present? }
    validates_uniqueness_of :email, if: Proc.new { |customer| customer.email.present? }

    has_many :orders, class_name: 'Glysellin::Order', foreign_key: :customer_id
    belongs_to :user, class_name: 'User'
    belongs_to :customer_type, class_name: 'Glysellin::CustomerType'

    accepts_nested_attributes_for :user, reject_if: :all_blank
    before_validation :setup_user_email

    def name
      full_name
    end

    def full_name
      [first_name, last_name, company_name].compact.join(' ')
    end

    def password_filled_in?
      user.password.present?
    end

    def company_name_filled_in?
      company_name.present?
    end

    def ensure_user!
      unless user
        self.update! user:
          create_user! do |u|
            u.email = email
            u.password = Devise.friendly_token.first(8)
          end
      end
    end

    private

    def setup_user_email
      return unless user.present? && !Rails.env.test?
      user.email = email
    end
  end
end
