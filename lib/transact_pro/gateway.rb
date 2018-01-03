class TransactPro::Gateway
  attr_reader :options

  DEFAULTS = {
    TEST: false,
    PRODUCTION_ENV: {
      API_URI: "https://www2.1stpayments.net/gwprocessor2.php"
    },
    TEST_ENV: {
      API_URI: "https://gw2sandbox.tpro.lv:8443/gw2test/gwprocessor2.php"
    }
  }.freeze

  def initialize(options)
    test = DEFAULTS[:TEST] || !!options[:TEST]

    env_key = (test ? :TEST_ENV : :PRODUCTION_ENV)

    @options = {
      TEST: test,
      API_URI: DEFAULTS[env_key][:API_URI],
      pwd: Digest::SHA1.hexdigest(options[:PASSWORD].to_s),
      guid: options[:GUID].to_s
    }

    @options.merge!(options)

    unless @options[:GUID].to_s[%r'\A(?:\w){4}-(?:\w){4}-(?:\w){4}-(?:\w){4}\z']
      raise ArgumentError.new("'#{@options[:GUID]}' is not a valid GUID for a gateway")
    end

    unless @options[:PASSWORD].to_s.size > 0
      raise ArgumentError.new("'#{@options[:PASSWORD]}' is not a valid PASSWORD for a gateway")
    end

    if @options[:ACCOUNT_3D].to_s.size < 1 && @options[:ACCOUNT_NON3D].to_s.size < 1
      raise ArgumentError.new("As a minimum specify a ACCOUNT_3D or a ACCOUNT_NON3D for a gateway")
    end
  end

  def request(request_options)
    TransactPro::Request.new(options.merge(request_options))
  end
end
