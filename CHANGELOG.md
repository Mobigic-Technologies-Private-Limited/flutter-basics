# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.0.2] 

### Added

- Initial release of **flutter_basics** package
- Introduced `MobigicLogger` for structured logging
- Supported log levels:
  - trace
  - debug
  - info
  - warning
  - error
  - fatal
- Automatic log disabling in **release (production) mode**
- Pretty and readable log output for debug builds
- Support for logging Dart objects (`Map`, `List`, `Set`, etc.)

### Behavior

- Logs are printed only in **debug/profile modes**
- Logs are completely suppressed in **release builds**

### Documentation

- Added comprehensive `README.md`
- Included usage examples and production-safety notes
