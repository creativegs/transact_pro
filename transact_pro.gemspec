
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "transact_pro/version"

Gem::Specification.new do |spec|
  spec.name          = "transact_pro"
  spec.required_ruby_version = '>= 2'
  spec.date          = "2018-01-04"
  spec.version       = TransactPro::VERSION
  spec.authors       = ["Epigene"]
  spec.email         = ["cto@creative.gs", "augusts.bautra@gmail.com"]

  spec.summary       = "Ruby wrapper for communicating with TransactPro 1stpayments.net card payment API."
  spec.homepage      = "https://github.com/CreativeGS/transact_pro"
  spec.license       = "BSD-3-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0.2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "webmock"#, "~> 3.7"
  spec.add_development_dependency "pry", "~> 0.11.3"
  spec.add_development_dependency "simplecov", "~> 0.15.1"
  spec.add_development_dependency "coveralls", "~> 0.7.1"

end
