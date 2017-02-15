class PaymentRequestForm
  @monitor = ->
    $('[data-payment-request-expires-at]').on 'submit', 'form', (e) ->
      $wrapper = $(e.currentTarget).closest('[data-payment-request-expires-at]')
      requestForm = new PaymentRequestForm($wrapper)
      requestForm.handleSubmission(e)

  constructor: (@$el) ->
    @expiresAt = parseInt(@$el.data('payment-request-expires-at'), 10) * 1000
    @expiredURL = @$el.data('payment-request-expired-url')

  handleSubmission: (e) ->
    # The form is still valid, let the form be submitted
    return true if @expiresAt > +(new Date)

    # The form has expired, prevent the form submission and redirect to
    # the expiration URL
    e.preventDefault()

    if Turbolinks?.supported
      Turbolinks.visit(@expiredURL)
    else
      window.location.href = @expiredURL


if Turbolinks?.supported
  $(document).on('page:change turbolinks:load', PaymentRequestForm.monitor)
else
  $(document).on('ready', PaymentRequestForm.monitor)
