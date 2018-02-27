# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2018-02-27
### Fixed
- Recurring inits now pass the `save_card: "1"` parameter and actually save card data. 

## [1.1.0] - 2018-02-20
### Added
- `LOOSENED_VALIDATIONS` gateway option.  

### Removed
- Requests, especially :init* types no longer have placeholder defaults, use `LOOSENED_VALIDATIONS` instead.  
