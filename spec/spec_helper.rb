require "bundler/setup"
require "cov_helper"
require "coveralls"; Coveralls.wear!
require "transact_pro"
require "pry"
require 'webmock'
unless ENV["USE_LIVE_SANDBOX"] == "true"
  WebMock.enable!
  WebMock.disable_net_connect!(allow_localhost: false)
end

abort("Please specify a valid USER_IP environmental variable") if ENV["USER_IP"].to_s.size < 1

Dir[TransactPro.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
