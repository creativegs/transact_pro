module RequestHelpers
  def init_request_options(options={})
    {
      method: :init,
      user_ip: ENV["USER_IP"] || "78.23.51.103",
      merchant_transaction_id: SecureRandom.uuid,
      description: "Test purchase",
      amount: "995", # as in 9.95
      currency: "EUR",
      merchant_site_url: "https://example.com",
    }
  end

  def init_recurring_registration_request_options(options={})
    {
      method: :init_recurring_registration,
      user_ip: ENV["USER_IP"] || "78.23.51.103",
      merchant_transaction_id: SecureRandom.uuid,
      description: "Test Subscription registration purchase",
      amount: "995", # as in 9.95
      currency: "EUR",
      merchant_site_url: "https://example.com",
    }
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
