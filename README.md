[![Version](https://badge.fury.io/rb/transact_pro.svg)](https://badge.fury.io/rb/transact_pro)
[![Build](https://circleci.com/gh/CreativeGS/transact_pro/tree/master.svg?style=shield)](https://circleci.com/gh/CreativeGS/transact_pro/tree/master)
[![Coverage](https://coveralls.io/repos/github/CreativeGS/transact_pro/badge.svg?branch=master)](https://coveralls.io/github/CreativeGS/transact_pro?branch=master)

# TransactPro
Lightweight Ruby wrapper for communicating with TransactPro 1stpayments.net card payment API.  

## Installation
Bundle or manually install the latest version of the gem:

```ruby
gem 'transact_pro'
```

## Usage
TODO

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/CreativeGS/transact_pro. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

The project uses TDD approach to software development, follow these steps to set up:
1. fork and clone the repo on github
2. Install appropriate Ruby and Bundler
3. `bundle`
4. See if all specs are green with `rspec`
5. TDD new features
6. Make a Pull Request in github

## Releasing a new version

```
gem push # to set credentials
rake release
```

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

## Code of Conduct

Everyone interacting in the TransactPro project’s codebases and issue trackers is expected to follow the [code of conduct](https://github.com/CreativeGS/transact_pro/blob/master/CODE_OF_CONDUCT.md).
