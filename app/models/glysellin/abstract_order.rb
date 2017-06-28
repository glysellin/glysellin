module Glysellin
  class AbstractOrder < ActiveRecord::Base
    self.table_name = 'glysellin_orders'

    include ProductsList
    include Orderer

    attr_accessor :discount_code

    has_many :line_items, class_name: 'Glysellin::LineItem', as: :container
    accepts_nested_attributes_for :line_items, allow_destroy: true,
                                  reject_if: :all_blank

    has_many :variants, through: :line_items, class_name: 'Glysellin::Variant'

    has_one :shipment, as: :shippable, dependent: :destroy
    accepts_nested_attributes_for :shipment, allow_destroy: true

    has_many :discounts, as: :discountable, inverse_of: :discountable
    accepts_nested_attributes_for :discounts, allow_destroy: true,
                                  reject_if: :all_blank

    validates :customer, :billing_address, :line_items, presence: true
    validates :shipping_address, presence: true,
              if: :use_another_address_for_shipping

    before_validation :process_total_price

    after_create :ensure_customer_addresses
    after_create :ensure_ref

    belongs_to :customer, class_name: 'Glysellin::Customer'
    belongs_to :store, class_name: 'Glysellin::Store'

    scope :from_customer, ->(customer_id) { where(customer_id: customer_id) }
    scope :active, -> { where.not(state: :canceled) }
    scope :unpaid, -> { where.not(payment_state: :paid) }

    def ensure_ref
      unless ref
        update_column(:ref, Glysellin.order_reference_generator.call(self))
      end
    end

    def process_total_price
      write_attribute(:total_price, total_price)
      write_attribute(:total_eot_price, total_eot_price)
    end

    def ensure_customer_addresses
      if customer && customer.billing_address.blank?
        customer.billing_address = billing_address.dup
        customer.use_another_address_for_shipping = use_another_address_for_shipping

        if use_another_address_for_shipping && customer.shipping_address.blank?
          customer.shipping_address = shipping_address.dup
        end

        customer.save!
      end
    end

    def email
      customer && customer.email
    end

    def name
      (customer && customer.name) || (billing_address && billing_address.name)
    end
  end
end
