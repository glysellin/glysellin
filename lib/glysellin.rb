require "active_model/model"
require "paperclip"
require "state_machine"

require "glysellin/engine"
require "glysellin/gateway"
require "glysellin/adjustment"
require "glysellin/discount_type_calculator"
require "glysellin/vat_rates"
require "glysellin/products_list"
require "glysellin/shipping_carrier"
# require "glysellin/cart"
require "glysellin/available_stock"
require "glysellin/order_stock_migration"
require "glysellin/payments"

module Glysellin
  ################################################################
  #
  # Config vars, to be overriden from generated initializer file
  #
  ################################################################

  # Status const to be used to define order step to payment
  ORDER_STEP_PAYMENT = 'payment'

  ################################################################
  #
  # Config vars, to be overriden from generated initializer file
  #
  ################################################################

  # Defines which user class will be used to bind Customer model to an
  #   authenticable user
  mattr_accessor :barcode_class_name
  mattr_accessor :user_class_name
  @@user_class_name = 'User'

  # Defines if SKU must be automatically set on product save
  mattr_accessor :autoset_sku
  @@autoset_sku = true

  # Has to be filled if there are additional address fields to
  #   store in database
  mattr_accessor :additional_address_fields
  @@additional_address_fields = []

  # Giving it a lambda will override Order reference
  #   string generation method
  mattr_accessor :order_reference_generator
  @@order_reference_generator = ->(order) {
    "#{ Time.now.strftime("%Y%m%d%H%M") }-#{ order.id }"
  }

  # Lambda used to generate invoice numbers when an invoice is created
  mattr_accessor :invoice_number_generator
  @@invoice_number_generator = ->(order) {
    (Glysellin::Invoice.last.try(:number) || 0).to_i + 1
  }

  # Defines if we will show the subtotal field in Order recaps if
  #   no adjustements are applied to the Order price
  mattr_accessor :show_subtotal_if_identical
  @@show_subtotal_if_identical = false

  # Define if we should show shipping price if it is equal to zero
  mattr_accessor :show_shipping_if_zero
  @@show_shipping_if_zero = false

  # The sender e-mail address used in order e-mails
  mattr_accessor :contact_email
  @@contact_email = 'orders@example.com'

  # The destination e-mail for order validations and other
  #   admin related e-mails
  mattr_accessor :admin_email
  @@admin_email = 'admin@example.com'

  # Public shop name used when referencing it inside
  #   the app and e-mails
  mattr_accessor :shop_name
  @@shop_name = 'Example Shop Name'

  mattr_accessor :default_store_client_key

  mattr_accessor :default_vat_rate
  @@default_vat_rate = 20

  mattr_accessor :default_product_weight
  @@default_product_weight = 0

  mattr_accessor :send_email_on_check_order_placed
  @@send_email_on_check_order_placed = true

  mattr_accessor :async_cart
  @@async_cart = true

  mattr_accessor :step_routes
  @@step_routes = {
    payment_method_chosen: ORDER_STEP_PAYMENT
  }

  # Product images paperclip styles
  mattr_accessor :product_images_styles
  @@product_images_styles = {
    :thumb => '100x100#',
    :content => '300x300'
  }

  mattr_accessor :allow_anonymous_orders
  @@allow_anonymous_orders = true

  def self.mailer_subjects=(hash = nil)
    @@mailer_subjects = -> { I18n.t('glysellin.mailer').merge(hash) }
  end

  mattr_accessor :mailer_subjects
  @@mailer_subjects = -> { I18n.t('glysellin.mailer') }

  # Permits using config block in order to set
  #   Glysellin module attributes
  #
  # Examples
  #
  #   Glysellin.config do |c|
  #     c.contact_email = 'orders@myshop.com'
  #   end
  #
  # Returns nothing
  def self.config
    yield self
  end
end
