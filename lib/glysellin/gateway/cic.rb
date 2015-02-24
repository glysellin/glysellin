module Glysellin
  module Gateway
    class Cic < Glysellin::Gateway::Base
      include ActionView::Helpers::FormHelper
      register 'cic', self

      attr_accessor :errors, :order

      def initialize order
        @order = order
        @errors = []
      end

      def render_request_button(options = {})
        request = CicPayment.new.request(montant: @order.total_price, reference: @order.id * (Rails.env.staging? ? rand(1000) : 1))
        { text: cic_payment_form(request, button_text: 'Procéder au paiement', button_class: 'btn btn-success btn-large').html_safe }
      end

      def process_payment! post_data
        raise true
        response = CicPayment.new.response post_data

        if response[:success]
          order = Order.find(response['reference'].to_i)
          order.paid!
          order.save!
        end

        if Rails.env.production?
          if response[:success] || response["code-retour"].downcase == "annulation"
            render text: "version=2\ncdr=0\n"
          else
            render text: "version=2\ncdr=1\n"
          end
        else
          if response[:success]
            flash[:notice] = "[DEV-MODE] Merci pour votre achat."
          else
            flash[:error] = "[DEV-MODE] Erreur survenue."
          end

          redirect_to root_path
        end
      end

      # The response returned within "render" method in the OrdersController#gateway_response method
      def response
        { nothing: true }
      end

      private

      def cic_payment_form(payment, options = {})

        options[:button_text] ||= 'Payer'
        options[:button_class] ||= ''

        html = "<form name='cic_payment_form' action='#{payment.target_url}' method='post'>\n"

        html << "  <input type='hidden' name='version'           id='version'        value='#{payment.version}' />\n"
        html << "  <input type='hidden' name='TPE'               id='TPE'            value='#{payment.tpe}' />\n"
        html << "  <input type='hidden' name='date'              id='date'           value='#{payment.date}' />\n"
        html << "  <input type='hidden' name='montant'           id='montant'        value='#{payment.montant}' />\n"
        html << "  <input type='hidden' name='reference'         id='reference'      value='#{payment.reference}' />\n"
        html << "  <input type='hidden' name='MAC'               id='MAC'            value='#{payment.hmac_token}' />\n"
        html << "  <input type='hidden' name='url_retour'        id='url_retour'     value='#{payment.url_retour}' />\n"
        html << "  <input type='hidden' name='url_retour_ok'     id='url_retour_ok'  value='#{payment.url_retour_ok}' />\n"
        html << "  <input type='hidden' name='url_retour_err'    id='url_retour_err' value='#{payment.url_retour_err}' />\n"
        html << "  <input type='hidden' name='lgue'              id='lgue'           value='#{payment.lgue}' />\n"
        html << "  <input type='hidden' name='societe'           id='societe'        value='#{payment.societe}' />\n"
        html << "  <input type='hidden' name='texte-libre'       id='texte-libre'    value='#{payment.texte_libre}' />\n"
        html << "  <input type='hidden' name='mail'              id='mail'           value='#{payment.mail}' />\n"

        html << "  <input type='submit' name='submit_cic_payment_form' value='#{options[:button_text]}' class='#{options[:button_class]}' />\n"
        html << "</form>\n"

        html.respond_to?(:html_safe) ? html.html_safe : html

      end
    end
  end
end
