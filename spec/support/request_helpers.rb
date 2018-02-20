module RequestHelpers
  def init_request_options(options={})
    params = {
      name_on_card: "John Doe",
      street: "n/a",
      zip: "n/a",
      city: "n/a",
      country: "LV",
      state: "n/a",
      phone: "003710000000"
    }.merge(options)

    init_minimal_request_options(options).merge(params)
  end

  def init_minimal_request_options(options={})
    {
      method: :init,
      user_ip: ENV["USER_IP"] || "78.23.51.103",
      merchant_transaction_id: SecureRandom.uuid,
      description: "Test purchase",
      amount: "995", # as in 9.95
      currency: "EUR",
      email: "john.doe@example.com",
      merchant_site_url: "https://example.com",
    }.merge(options)
  end

  def init_recurring_registration_request_options(options={})
    params = {
      method: :init_recurring_registration,
      description: "Test Subscription registration purchase",
    }.merge(options)

    init_request_options(options).merge(params)
  end

  def init_recurrent_request_options(options={})
    {
      method: :init_recurrent,
      original_init_id: "b327adac3953bc768442ff75315c83400fa55433",
      merchant_transaction_id: SecureRandom.uuid,
      amount: "695", # as in 6.95
      description: "Test Subscription recurrent charge"
    }
  end

  def charge_recurrent_request_options(options={})
    {
      method: :charge_recurrent,
      init_transaction_id: "b327adac3953bc768442ff75315c83400fa55434"
    }
  end

  def status_request_request_options(options={})
    {
      method: :status_request,
      init_transaction_id: "b327adac3953bc768442ff75315c83400fa55435"
    }
  end
end
