module ActionDispatch::Routing
  class Mapper
    def glysellin_at(mount_location, options = {})

      controllers = parse_controllers(options)

      scope mount_location do
        resources :orders, controller: controllers[:orders], :only => [] do
          collection do
            get 'payment_response'
            post 'gateway/:gateway', :action => 'gateway_response', :as => 'named_gateway_response'
            match 'gateway/response/:type', :action => 'payment_response', :as => 'typed_payment_response', via: [:get, :post]
          end

          member do
            post 'gateway-response', :action => 'gateway_response', :as => 'gateway_response'
            match 'payment_response', via: [:get, :post]
          end
        end

        resource :cart, controller: controllers[:cart], only: [:show, :destroy] do
          resources :products, controller: 'glysellin/cart_steps/products', only: [:create, :update, :destroy] do
            collection do
              put 'contents/validate', action: 'validate', as: 'validate'
            end
          end

          resource :discount_code, controller: 'glysellin/cart_steps/discount_codes', only: [:update]
          resource :addresses, controller: 'glysellin/cart_steps/addresses', only: [:update]
          resource :shipping_method, controller: 'glysellin/cart_steps/shipping_method', only: [:update]
          resource :order_creation, controller: 'glysellin/cart_steps/order_creation', only: [:update]
          resource :state, controller: 'glysellin/cart_steps/state', only: [:show] do
            get ':state', action: 'show', as: 'set'
          end
        end

        resource :order, controller: 'glysellin/order', only: [:show]

        scope module: 'glysellin' do
          namespace :api do
            resources :properties, only: :index
            resources :property_types, only: :index
            resources :orders, only: :create
          end
        end
        # get '/' => 'glysellin/products#index', as: 'shop'
      end
    end

    # Allows user to define app controllers to handle glysellin routes
    def parse_controllers options
      defaults = {
        orders: 'glysellin/orders',
        cart: 'glysellin/cart'
      }

      defaults.merge(options.fetch(:controllers, {}))
    end
  end
end
