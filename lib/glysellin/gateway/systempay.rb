module Glysellin
  module Gateway
    class Systempay < Glysellin::Gateway::Base
      register 'system_pay', self

      attr_accessor :errors, :order

      def initialize order
        @order = order
        @errors = []
      end

      class << self
        # Extract order id from response data since it cannot be dynamically given via get URL
        def parse_order_id data
          data_param = Rack::Utils.parse_nested_query(data)
          Glysellin::Order.find_by_ref data_param['vads_order_id']
        end
      end

      def render_request_button(options = {})
        @system_pay = SystemPay::Vads.new(
          :amount => (@order.total_price * 100).to_i.to_s,
          :trans_id => @order.payment.get_new_transaction_id,
          :order_id => @order.ref,
          :capture_delay => 0
        )
        {
          :partial => 'glysellin/payment_methods/system_pay',
          locals: { system_pay: @system_pay }
        }
      end

      # Launch payment processing
      def process_payment!(post_data)
        transaction_data = Rack::Utils.parse_nested_query(post_data)
        results = SystemPay::Vads.diagnose(transaction_data.with_indifferent_access)

        # Réponse acceptée
        valid = results[:status] == :success

        result = valid ? @order.pay! : false

        @order.payment.update_attributes(transaction_data: transaction_data) if @order.payment
        @order.save

        result
      end

      # The response returned within "render" method in the OrdersController#gateway_response method
      def response
        { nothing: true }
      end

      protected

      def shell_escape(str)
        String(str).gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').gsub(/\n/, "'\n'").sub(/^$/, "''")
      end
    end
  end
end
