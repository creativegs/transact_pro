module GatewayHelpers
  def sandbox_gateway_options
    {
      TEST: !!ENV["USE_LIVE_SANDBOX"],
      LOOSENED_VALIDATIONS: false,
      GUID: "CAZY-7319-WI00-0C40", # mandatory
      PASSWORD: "g44B/pAENO2E", # mandatory
      ACCOUNT_3D: "CS01",
      ACCOUNT_NON3D: "CS02",
      ACCOUNT_RECURRING: "CS03"
    }
  end

  def sandbox_gateway
    TransactPro::Gateway.new(sandbox_gateway_options)
  end

  def loosened_sandbox_gateway
    TransactPro::Gateway.new(
      sandbox_gateway_options.merge(LOOSENED_VALIDATIONS: true)
    )
  end
end
