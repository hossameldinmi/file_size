/// A lightweight Dart library for handling file size conversions and formatting.
///
/// This library provides the [SizedFile] class for easy file size manipulation
/// across different units (bytes, KB, MB, GB, TB) with support for custom
/// formatting and internationalization.
///
/// Example usage:
/// ```dart
/// import 'package:sized_file/sized_file.dart';
///
/// void main() {
///   final fileSize = SizedFile.mb(5);
///   print(fileSize.format()); // "5.00 MB"
///   print(fileSize.inBytes);  // 5242880
/// }
/// ```
library sized_file;

import 'dart:math';

/// A utility class for handling file size conversions and formatting.
///
/// The [SizedFile] class provides an easy way to work with file sizes across
/// different units (bytes, kilobytes, megabytes, gigabytes, terabytes).
/// It uses 1024 as the divider (binary) for accurate storage size calculations.
///
/// Example:
/// ```dart
/// final fileSize = FileSize.mb(5);
/// print(fileSize.format()); // "5.00 MB"
/// print(fileSize.inBytes);  // 5242880
/// ```
class SizedFile {
  /// The divider used for unit conversions (1024 for binary).
  ///
  /// This aligns with how most operating systems and storage devices
  /// report file sizes (KiB, MiB, GiB rather than KB, MB, GB).
  static const int _divider = 1024;

  /// Creates a [SizedFile] instance from bytes.
  ///
  /// The byte value must be non-negative. All other unit values
  /// (KB, MB, GB) are automatically calculated.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.b(1024);
  /// print(fileSize.inKB); // 1.0
  /// ```
  ///
  /// Throws [AssertionError] if [inBytes] is negative.
  SizedFile.b(this.inBytes)
    : assert(inBytes >= 0, 'File size cannot be negative'),
      inKB = inBytes / _divider,
      inMB = inBytes / pow(_divider, 2),
      inGB = inBytes / pow(_divider, 3);

  /// The size in bytes.
  ///
  /// This is the primary storage unit for the file size.
  final int inBytes;

  /// The size in kilobytes (KB).
  ///
  /// Calculated as bytes / 1024.
  final double inKB;

  /// The size in megabytes (MB).
  ///
  /// Calculated as bytes / (1024²).
  final double inMB;

  /// The size in gigabytes (GB).
  ///
  /// Calculated as bytes / (1024³).
  final double inGB;

  /// Creates a [SizedFile] instance from kilobytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.kb(1.5);
  /// print(fileSize.inBytes); // 1536
  /// ```
  SizedFile.kb(double inKB) : this.b((inKB * _divider).toInt());

  /// Creates a [SizedFile] instance from megabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.mb(100);
  /// print(fileSize.inBytes); // 104857600
  /// ```
  SizedFile.mb(double inMB) : this.b((inMB * pow(_divider, 2)).toInt());

  /// Creates a [SizedFile] instance from gigabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.gb(2.5);
  /// print(fileSize.inMB); // 2560.0
  /// ```
  SizedFile.gb(double inGB) : this.b((inGB * pow(_divider, 3)).toInt());

  /// Creates a [SizedFile] instance from terabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.tb(1);
  /// print(fileSize.inGB); // 1024.0
  /// ```
  SizedFile.tb(double inTB) : this.b((inTB * pow(_divider, 4)).toInt());

  /// Formats the file size as a human-readable string.
  ///
  /// Automatically selects the most appropriate unit based on the size:
  /// - Less than 1 KB: displays in bytes (B)
  /// - Less than 1 MB: displays in kilobytes (KB)
  /// - Less than 1 GB: displays in megabytes (MB)
  /// - 1 GB or more: displays in gigabytes (GB)
  ///
  /// Parameters:
  /// - [fractionDigits]: Number of decimal places to show (default: 2).
  ///   Note: Bytes are always shown as integers without decimals.
  /// - [postfixes]: Optional custom unit labels. If not provided, uses
  ///   the global postfix generator set via [setPostfixesGenerator].
  ///
  /// Example:
  /// ```dart
  /// final fileSize = SizedFile.kb(1.5);
  /// print(fileSize.format());                    // "1.50 KB"
  /// print(fileSize.format(fractionDigits: 0));   // "2 KB"
  ///
  /// final custom = {'B': 'bytes', 'KB': 'kilobytes', 'MB': 'megabytes', 'GB': 'gigabytes'};
  /// print(fileSize.format(postfixes: custom));   // "1.50 kilobytes"
  /// ```
  ///
  /// Returns a formatted string with the size and appropriate unit.
  String format({int fractionDigits = 2, Map<String, String>? postfixes}) {
    // Use provided postfixes or fall back to the global generator
    postfixes ??= _postfixesGenerator();

    // Select the most appropriate unit based on size
    if (inBytes < _divider) {
      // Display in bytes (no decimals for byte values)
      return '$inBytes ${postfixes['B']}';
    } else if (inKB < _divider) {
      // Display in kilobytes
      return '${inKB.toStringAsFixed(fractionDigits)} ${postfixes['KB']}';
    } else if (inMB < _divider) {
      // Display in megabytes
      return '${inMB.toStringAsFixed(fractionDigits)} ${postfixes['MB']}';
    } else {
      // Display in gigabytes (for 1 GB and above)
      return '${inGB.toStringAsFixed(fractionDigits)} ${postfixes['GB']}';
    }
  }

  /// Sets a global postfix generator for all [SizedFile] instances.
  ///
  /// This is useful for internationalization or custom unit labeling.
  /// The generator function will be called whenever [format] needs
  /// default postfixes.
  ///
  /// Example:
  /// ```dart
  /// // Set custom postfixes
  /// SizedFile.setPostfixesGenerator(() {
  ///   return {
  ///     'B': 'B',
  ///     'KB': 'KB',
  ///     'MB': 'MB',
  ///     'GB': 'GB',
  ///     'TB': 'TB',
  ///   };
  /// });
  ///
  /// final fileSize = SizedFile.mb(5);
  /// print(fileSize.format()); // Uses custom postfixes
  /// ```
  ///
  /// Parameters:
  /// - [generator]: A function that returns a map of unit postfixes.
  ///   The map should contain keys: 'B', 'KB', 'MB', 'GB', 'TB'.
  static void setPostfixesGenerator(Map<String, String> Function() generator) {
    _postfixesGenerator = generator;
  }

  /// The global postfix generator function.
  ///
  /// Returns a map of default English unit labels.
  /// Can be overridden using [setPostfixesGenerator].
  static Map<String, String> Function() _postfixesGenerator = () {
    return <String, String>{
      'B': 'B',
      'KB': 'KB',
      'MB': 'MB',
      'GB': 'GB',
      'TB': 'TB',
    };
  };
}
