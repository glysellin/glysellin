class Glysellin::OrderAdminMailer < ActionMailer::Base
  default from: Glysellin.contact_email, to: Glysellin.admin_email

  def send_order_paid_email order
    @order = order
    mail(
      subject: I18n.t('glysellin.mailer.admin.send_order_paid_email', ref: @order.ref)
    )
  end

  def send_check_order_created_email order
    @order = order
    mail(
      subject: I18n.t('glysellin.mailer.admin.send_check_order_created_email', ref: @order.ref)
    )
  end
end
