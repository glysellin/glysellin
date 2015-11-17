Coeur :
  - Order
  - Cart
  - Sellable
  - Payment methods
  - Shipping methods



class Customer
  - Billing address
  - Shipping address

class Cart
  - Line items

class Wishlist
  - Line items
  - Customer

class Order
  - Line items
  - Customer
  - Billing address
  - Shipping address
  - Payment method
  - Shipping method

------------------------------------------------------------------------

class Customer
  include Billable
  include Shippable

class Cart
  include LineItemsManager

class Order
  include LineItemsManager
  include Billable
  include Shippable

class Wishlist
  include LineItemsManager


class LineItem
  belongs_to :original_sellable, polymorphic: true

  attributes :name, :image_url, ...


module ActsAsSellable
  def to_line_item(line_item)
    line_item.tap do |line_item|
      line_item.
    end
  end
end


module Cart
  class AddLineItem < Glysellin::Action::Base
    attr_reader :cart, :sellable

    def initialize(cart, sellable)
      @cart = cart
      @sellable = sellable
    end

    def execute
      line_item = sellable.to_line_item
      line_item.original_sellable = sellable

      cart.line_items << line_item

      unless Glysellin::StockService.in_stock?(line_item)
        line_item.errors.add(:stock, :empty)
        return false
      end

      cart.save
    end
  end
end


Boutique
  -> Add to cart
    -> créer line item
    -> check stocks
      -> Si pas en stock
        -> Modale -> Produit non disponible

    -> Enregistrement du panier

  -> Remove from cart
    -> Récupérer line item
    -> Supprimer line item




Glysellin.config do |config|
  config.cart_steps :validate, :addresses, :shipping_method, :payment_method
  config.cart_steps :validate, :customer, :informations
end

module Cart
  module Actions
    class Base
      attr_reader :cart, :params

      def initialize(cart, params)
        @cart = cart
        @params = params
      end
    end
  end
end

module Cart
  module Actions
    class Validate < Cart::Actions::Base
      def execute

      end
    end
  end
end


class OrderController
  def edit
    render 'cart/show'
  end

  def update
    if next_cart_action.new(@cart, params.require(:cart)).execute
      flash_success
      redirect_to ''
    else
      flash_error
      render ''
    end
  end
end

