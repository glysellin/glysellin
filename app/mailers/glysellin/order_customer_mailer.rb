class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_created_email order
    @order = order
    mail to: @order.email
  end

  def send_order_paid_email order
    @order = order

    if Glysellin.order_paid_email_attachments
      Glysellin.order_paid_email_attachments.call(order).each do |attachment|
        attachments.inline[attachment.file_name] = attachment.read
      end
    end

    mail to: @order.email
  end
end
