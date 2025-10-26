import 'dart:math';
import 'package:sized_file/src/byte_converter.dart';

/// A strategy class for managing file size unit conversions.
///
/// [ConverterStrategy] provides a centralized approach to converting between
/// bytes and larger units (KB, MB, GB, TB). It uses a configurable divider
/// (default: 1024) to perform binary-based conversions, which aligns with
/// how most operating systems and storage devices report file sizes.
///
/// The class exposes pre-configured [ByteConverter] instances for each unit:
/// - [kb]: Kilobyte converter (divider^1)
/// - [mb]: Megabyte converter (divider^2)
/// - [gb]: Gigabyte converter (divider^3)
/// - [tb]: Terabyte converter (divider^4)
///
/// Example usage:
/// ```dart
/// final strategy = ConverterStrategy(); // Uses 1024 as divider
/// print(strategy.kb.toBytes(1));   // 1024
/// print(strategy.mb.toBytes(1));   // 1048576
/// print(strategy.gb.fromBytes(1073741824)); // 1.0
/// ```
class ConverterStrategy {
  /// The divider used for all unit conversions (default: 1024 for binary).
  ///
  /// This value represents the number of bytes in one kilobyte. Using 1024
  /// aligns with the binary system (2^10), which is the standard for:
  /// - Operating systems (Windows, macOS, Linux)
  /// - File system representations (KiB, MiB, GiB)
  /// - Most storage device specifications
  ///
  /// Note: This differs from the decimal system (1000) sometimes used in
  /// marketing (e.g., hard drive manufacturers).
  final int divider;

  /// Creates a [ConverterStrategy] with the specified divider.
  ///
  /// Parameters:
  /// - [divider]: The multiplier between units (default: 1024).
  ///   Use 1024 for binary units (KiB, MiB) or 1000 for decimal units (KB, MB).
  ///
  /// Example:
  /// ```dart
  /// final binaryStrategy = ConverterStrategy(1024); // Standard
  /// final decimalStrategy = ConverterStrategy(1000); // Marketing style
  /// ```
  ConverterStrategy([this.divider = 1024]);

  /// Converter for kilobytes (KB).
  ///
  /// Converts between bytes and kilobytes using the formula:
  /// - To bytes: value × divider
  /// - From bytes: bytes ÷ divider
  late final kb = ByteConverter(
    (kb) => (kb * divider).toInt(),
    (bytes) => bytes / divider,
  );

  /// Converter for megabytes (MB).
  ///
  /// Converts between bytes and megabytes using divider^2.
  late final mb = _genConverter(2);

  /// Converter for gigabytes (GB).
  ///
  /// Converts between bytes and gigabytes using divider^3.
  late final gb = _genConverter(3);

  /// Converter for terabytes (TB).
  ///
  /// Converts between bytes and terabytes using divider^4.
  late final tb = _genConverter(4);

  /// Generates a [ByteConverter] for a unit based on an exponent.
  ///
  /// Creates a converter that uses [divider] raised to the specified
  /// [exponent] for conversions. This allows consistent scaling across
  /// different unit magnitudes.
  ///
  /// Parameters:
  /// - [exponent]: The power to raise the divider to (2 for MB, 3 for GB, etc.)
  ///
  /// Returns a [ByteConverter] configured for the specified unit magnitude.
  ByteConverter _genConverter(int exponent) {
    return ByteConverter(
      (v) => (v * pow(divider, exponent)).toInt(),
      (bytes) => bytes / pow(divider, exponent),
    );
  }
}
