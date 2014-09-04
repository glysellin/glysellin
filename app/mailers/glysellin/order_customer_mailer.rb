class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_created_email(order)
    @order = order
    mail(
      to: @order.customer.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_created_email]
    )
  end

  def send_order_paid_email(order)
    @order = order

    if Glysellin.order_paid_email_attachments
      Glysellin.order_paid_email_attachments.call(order).each do |attachment|
        attachments.inline[attachment.file_name] = attachment.read
      end
    end

    mail(
      to: @order.customer.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_paid_email]
    )
  end

  def send_order_shipped_email(order)
    @order = order

    return unless order.email.presence

    mail(
      to: @order.customer.email,
      subject: Glysellin.mailer_subjects.call[:customer][:send_order_shipped_email]
    )
  end
end
