# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-21

### Added
- Initial release of the `sized_file` package
- `SizedFile` class for handling file size conversions and formatting
- Support for multiple size units: bytes (B), kilobytes (KB), megabytes (MB), gigabytes (GB), and terabytes (TB)
- Constructors for creating instances from any unit: `SizedFile.b()`, `SizedFile.kb()`, `SizedFile.mb()`, `SizedFile.gb()`, `SizedFile.tb()`
- Properties to access size in different units: `inBytes`, `inKB`, `inMB`, `inGB`
- Smart `format()` method that automatically selects the most appropriate unit for display
- Customizable fraction digits in formatting (default: 2 decimal places)
- Support for custom postfixes (unit labels) per format call
- Global postfix generator for internationalization support via `setPostfixesGenerator()`
- Binary divider (1024) for accurate storage size calculations
- Comprehensive unit tests with 32 test cases covering all features
- Complete API documentation with examples
- Example code demonstrating real-world use cases
- README with detailed usage instructions and practical examples

### Features
- Zero dependencies - pure Dart implementation
- Lightweight and performant
- Type-safe API with proper error handling
- Fully documented code with dartdoc comments
- Tested and verified with 100% test coverage

[1.0.0]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.0.0

## [1.0.1] - 2025-10-21

### Added
- remove unnecessary_library_name rule from analysis_options.yaml

