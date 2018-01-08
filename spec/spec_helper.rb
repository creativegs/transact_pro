require "bundler/setup"
require "cov_helper"
require "transact_pro"
require "pry"
require 'webmock'
unless ENV["USE_LIVE_SANDBOX"] == "true"
  WebMock.enable!
  WebMock.disable_net_connect!(allow_localhost: false)
end

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
