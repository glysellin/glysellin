require 'money'
require 'offsite_payments'
require 'offsite_payments/action_view_helper'

ActionView::Base.send(:include, OffsitePayments::ActionViewHelper)

module Glysellin
  module Gateway
    class PaypalIntegral < Glysellin::Gateway::Base
      include OffsitePayments::Integrations
      register 'paypal-integral', self

      mattr_accessor :account
      @@account = ''

      # Production mode by default
      mattr_accessor :test
      @@test = false

      attr_accessor :errors, :order

      def initialize order
        @order = order
        @errors = []
      end

      # Switch between test and prod modes for OffsitePayments Paypal
      class << self
        def test=(val)
          OffsitePayments.mode = val ? :test : :production
          @@test = val
        end
      end

      def render_request_button(options = {})
        {
          :partial => 'glysellin/payment_methods/paypal_integral',
          :locals => { :order => @order }
        }
      end

      # Launch payment processing
      def process_payment!(post_data)
        transaction_data = Rack::Utils.parse_nested_query(post_data)
        notification = Paypal::Notification.new(post_data)

        log "Processing payment from #{ post_data }"

        if notification.acknowledge
          begin
            if notification.complete?
              @order.paid!
            else
              error = "Failed to verify Paypal's notification, please investigate"
              @errors.push(error)
              false
            end
          rescue => e
            raise
          ensure
            @order.payment.update_attributes(transaction_data: transaction_data) if @order.payment
            @order.save
          end
        else
          false
        end
      end

      # The response returned within "render" method in the OrdersController#gateway_response method
      def response
        {:nothing => true}
      end
    end
  end
end
