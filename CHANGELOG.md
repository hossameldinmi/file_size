# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2025-10-26

### Added
- Extension methods on `num` for convenient `SizedFile` creation
  - `.b` extension: Creates `SizedFile` from bytes (converts to integer)
  - `.kb` extension: Creates `SizedFile` from kilobytes
  - `.mb` extension: Creates `SizedFile` from megabytes
  - `.gb` extension: Creates `SizedFile` from gigabytes
  - `.tb` extension: Creates `SizedFile` from terabytes
  - Example: `5.mb` is equivalent to `SizedFile.mb(5)`
- Comprehensive test coverage for all extension methods (10 new tests, 126 total)
- Extension methods documentation in README with usage examples and comparison table

### Changed
- Enhanced documentation across all source files:
  - `ByteConverter`: Added comprehensive class and method documentation
  - `UnitConverter` (formerly `ConverterStrategy`): Enhanced documentation with detailed explanations
  - `numericExtensions`: Added detailed documentation for each extension method
  - `SizedFile`: Improved documentation for `_strategy`, `_postfixesGenerator`, `format()`, and `setPostfixesGenerator()`
- Improved `format()` method documentation with clearer unit selection criteria including TB range
- Updated README Features section to highlight extension methods

### Improved
- Better code readability with expressive extension syntax
- More intuitive API for creating file size instances
- Clearer documentation throughout the codebase

## [1.2.2] - 2025-10-23

### Added
- `inTB` property for accessing file size in terabytes
- Documentation examples for `inTB` property in code, README, and example files
- Comprehensive unit tests for `inTB` property conversions

### Changed
- **BREAKING**: `SizedFile.min()` now accepts `Iterable<SizedFile>` instead of two parameters
  - Returns the smallest size from a collection
  - Returns zero if the collection is empty
  - Example: `SizedFile.min([size1, size2, size3])`
- **BREAKING**: `SizedFile.max()` now accepts `Iterable<SizedFile>` instead of two parameters
  - Returns the largest size from a collection
  - Returns zero if the collection is empty
  - Example: `SizedFile.max([size1, size2, size3])`
- **BREAKING** renaming  `SizedFile.values()` to `SizedFile.units()` factory constructor for creating instances from multiple units
  - Accepts optional named parameters: `b`, `kb`, `mb`, `gb`, `tb`
  - Example: `SizedFile.units(gb: 2, mb: 500, kb: 256)` creates a file size of 2 GB + 500 MB + 256 KB
  - Efficiently ignores zero values
  - All parameters default to 0
- Updated all examples and documentation to reflect new `min()` and `max()` signatures
- Improved `_ByteConverter` class with better encapsulation (renamed to private)

## [1.2.0] - 2025-10-22

### Added
  - `SizedFile.units()` factory constructor for creating instances from multiple units
  - Accepts optional named parameters: `b`, `kb`, `mb`, `gb`, `tb`
  - Example: `SizedFile.units(gb: 2, mb: 500, kb: 256)` creates a file size of 2 GB + 500 MB + 256 KB
  - Efficiently ignores zero values
  - All parameters default to 0
- Complete documentation for `SizedFile.units` with usage examples in README
- 8 new unit tests for `SizedFile.units` factory constructor (112 total tests)
- Practical examples in example/main.dart demonstrating mixed units use cases

## [1.1.2] - 2025-10-22

### Added
- Equality and comparison operators (`==`, `<`, `<=`, `>`, `>=`)
- Hash code support for use in `Set` and `Map` collections
- Arithmetic operators for addition (`+`) and subtraction (`-`)
- Multiplication operator (`*`) for scaling by numeric factors
- Division operator (`/`) for dividing by numeric values (returns `SizedFile`)
- `Comparable<SizedFile>` interface implementation with `compareTo()` method
- Static helper methods: `min()`, `max()`, `sum()`, `average()`
- New `ratioTo()` method for calculating ratios between two `SizedFile` instances
  - Returns `double` representing the ratio
  - Example: `used.ratioTo(total)` returns 0.244 for 250 MB / 1 GB
- `SizedFile.zero` static constant for zero-byte instances
- Comprehensive test suite expanded to 104 tests
- Advanced features examples demonstrating all new capabilities
- Equality and comparison focused example file

### Changed
- Updated all documentation to reflect the new API
- Updated README.md with arithmetic operations, static helpers, and comparison features
- Updated all example files to use `ratioTo()` for ratio calculations
- Simplified test expectations by removing unnecessary `equals()` matchers

### Fixed
- Removed ambiguous division operator behavior
- Improved code clarity with dedicated methods for different operations

## [1.0.2] - 2025-10-21

### Changed
- Enhanced documentation

## [1.0.1] - 2025-10-21

### Changed
- Removed `unnecessary_library_name` rule from analysis_options.yaml

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

[1.3.0]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.3.0
[1.2.2]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.2.2
[1.2.0]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.2.0
[1.1.2]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.1.2
[1.0.2]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.0.2
[1.0.1]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.0.1
[1.0.0]: https://github.com/hossameldinmi/sized_file/releases/tag/v1.0.0

