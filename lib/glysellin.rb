require 'active_model/model'
require 'paperclip'
require 'state_machines'
require 'state_machines-activerecord'
require 'acts-as-taggable-on'
require 'request_store'

require 'countries'
require 'country_select'

require 'glysellin/engine'
require 'glysellin/gateway'
require 'glysellin/adjustment'
require 'glysellin/discount_type_calculator'
require 'glysellin/vat_rates'
require 'glysellin/products_list'
require 'glysellin/shipping_carrier'
require 'glysellin/available_stock'
require 'glysellin/order_stock_migration'
require 'glysellin/payments'
require 'glysellin/barcode_generator'

module Glysellin
  # Defines which user class will be used to bind Customer model to an
  #   authenticable user
  mattr_accessor :barcode_class_name
  @@barcode_class_name = 'Glysellin::BarcodeGenerator'

  mattr_accessor :user_class_name
  @@user_class_name = 'User'

  # Pass the name of a class to be initialized with a cart and
  # implementing a #call method where line items, product prices,
  # discounts can be modified or deleted.
  # This will be called when fetching a cart
  mattr_accessor :cart_expiration_checker
  @@cart_expiration_checker = nil

  mattr_accessor :sign_in_after_user_selection
  @@sign_in_after_user_selection = false

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

  mattr_accessor :multi_store
  @@multi_store = false

  mattr_accessor :default_vat_rate
  @@default_vat_rate = 20

  mattr_accessor :default_product_weight
  @@default_product_weight = 0

  mattr_accessor :send_email_on_check_order_placed
  @@send_email_on_check_order_placed = true

  mattr_accessor :async_cart
  @@async_cart = true

  # Product images paperclip styles
  mattr_accessor :product_images_styles
  @@product_images_styles = {
    :thumb => '100x100#',
    :content => '300x300'
  }

  mattr_accessor :allow_anonymous_orders
  @@allow_anonymous_orders = true

  mattr_accessor :order_paid_email_attachments
  @@order_paid_email_attachments = nil

  mattr_accessor :default_stock_alert_threshold
  @@default_stock_alert_threshold = 0

  # Allows using config block in order to set
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
