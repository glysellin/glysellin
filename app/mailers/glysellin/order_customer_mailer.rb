class Glysellin::OrderCustomerMailer < ActionMailer::Base
  default from: Glysellin.contact_email

  def send_order_created_email(order)
    @order = order
    @email = @order.customer.email || @order.customer.user.email

    mail(
      to: @email,
      subject: I18n.t('glysellin.mailer.customer.send_order_created_email', ref: @order.ref)
    )
  end

  def send_order_paid_email(order)
    @order = order
    @email = @order.customer.email || @order.customer.user.email

    if Glysellin.order_paid_email_attachments
      Glysellin.order_paid_email_attachments.call(order).each do |attachment|
        attachments.inline[attachment.file_name] = attachment.read
      end
    end

    mail(
      to: @email,
      subject: I18n.t('glysellin.mailer.customer.send_order_paid_email', ref: @order.ref)
    )
  end

  def send_order_shipped_email(order)
    @order = order
    @email = @order.customer.email || @order.customer.user.email

    mail(
      to: @email,
      subject: I18n.t('glysellin.mailer.customer.send_order_shipped_email', ref: @order.ref)
    )
  end
end
