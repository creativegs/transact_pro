module RequestHelpers
  def init_request_options(options={})
    {
      method: :init,
      merchant_transaction_id: SecureRandom.uuid,
      description: "Test purchase",
      amount: "995", # as in 9.95
      currency: "EUR",
      merchant_site_url: "https://example.com",
    }
  end
end
