require "digest"
require "rest-client"

require "transact_pro/request_specs"
require "transact_pro/gateway"
require "transact_pro/request"
require "transact_pro/response"
require "transact_pro/version"

module TransactPro
  extend self

  DEFAULTS = {
    TEST: false,
    LOOSENED_VALIDATIONS: false,
    PRODUCTION_ENV: {
      API_URI: "https://www2.1stpayments.net/gwprocessor2.php",
      HOSTED_FIELDS_JS_URI: "https://www2.1stpayments.net/hostedfields/hosted-fields-1.0.5.js",
      HOSTED_FIELDS_SUBMIT_URI: "https://www2.1stpayments.net",
    },
    TEST_ENV: {
      API_URI: "https://gw2sandbox.tpro.lv:8443/gw2test/gwprocessor2.php",
      HOSTED_FIELDS_JS_URI: "https://gw2sandbox.tpro.lv:8443/gw2test/hostedfields/hosted-fields-1.0.5.js",
      HOSTED_FIELDS_SUBMIT_URI: "https://gw2sandbox.tpro.lv:8443/gw2test",
    }
  }.freeze

  def root
    @@root ||= Pathname.new(Gem::Specification.find_by_name("transact_pro").gem_dir)
  end
end
