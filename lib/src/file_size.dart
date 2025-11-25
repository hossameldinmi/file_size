import 'package:file_sized/src/converter_strategy.dart';

/// A utility class for handling file size conversions and formatting.
///
/// The [FileSize] class provides an easy way to work with file sizes across
/// different units (bytes, kilobytes, megabytes, gigabytes, terabytes).
/// It uses 1024 as the divider (binary) for accurate storage size calculations.
///
/// Example:
/// ```dart
/// final fileSize = FileSize.mb(5);
/// print(fileSize.format()); // "5.00 MB"
/// print(fileSize.inBytes);  // 5242880
/// ```
class FileSize implements Comparable<FileSize> {
  /// The conversion strategy used for all unit conversions.
  ///
  /// This static instance manages the conversion logic between different
  /// file size units (bytes, KB, MB, GB, TB) using a consistent divider
  /// of 1024 (binary units).
  static final _strategy = ConverterStrategy();

  /// Creates a [FileSize] instance with zero bytes.
  ///
  /// This is a convenience factory for creating empty file sizes,
  /// useful as initial values in calculations.
  ///
  /// Example:
  /// ```dart
  /// final total = FileSize.zero;
  /// // Use in calculations
  /// final result = total + FileSize.mb(10);
  /// ```
  static final zero = FileSize.b(0);

  /// Creates a [FileSize] instance from bytes.
  ///
  /// The byte value must be non-negative. All other unit values
  /// (KB, MB, GB) are automatically calculated.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.b(1024);
  /// print(fileSize.inKB); // 1.0
  /// ```
  ///
  /// Throws [AssertionError] if [inBytes] is negative.
  FileSize.b(this.inBytes)
      : assert(inBytes >= 0, 'File size cannot be negative'),
        inKB = _strategy.kb.fromBytes(inBytes),
        inMB = _strategy.mb.fromBytes(inBytes),
        inGB = _strategy.gb.fromBytes(inBytes),
        inTB = _strategy.tb.fromBytes(inBytes);

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
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.tb(1);
  /// print(fileSize.inGB); // 1024.0
  /// ```
  final double inGB;

  /// The size in terabytes (TB).
  ///
  /// Calculated as bytes / (1024⁴).
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.gb(5);
  /// print(fileSize.inTB); // 0.0048828125
  /// ```
  final double inTB;

  /// Creates a [FileSize] instance from kilobytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.kb(1.5);
  /// print(fileSize.inBytes); // 1536
  /// ```
  FileSize.kb(num inKB) : this.b(_strategy.kb.toBytes(inKB));

  /// Creates a [FileSize] instance from megabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.mb(100);
  /// print(fileSize.inBytes); // 104857600
  /// ```
  FileSize.mb(num inMB) : this.b(_strategy.mb.toBytes(inMB));

  /// Creates a [FileSize] instance from gigabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.gb(2.5);
  /// print(fileSize.inMB); // 2560.0
  /// ```
  FileSize.gb(num inGB) : this.b(_strategy.gb.toBytes(inGB));

  /// Creates a [FileSize] instance from terabytes.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.tb(1);
  /// print(fileSize.inGB); // 1024.0
  /// ```
  FileSize.tb(num inTB) : this.b(_strategy.tb.toBytes(inTB));

  /// Creates a [FileSize] instance by combining multiple unit values.
  ///
  /// This factory constructor allows you to specify a file size using a mix
  /// of different units, which are then summed together. This is useful when
  /// you have a size expressed in multiple units (e.g., "2 GB and 500 MB").
  ///
  /// All parameters are optional and default to 0. Any zero values are
  /// automatically ignored for efficiency.
  ///
  /// Parameters:
  /// - [bytes]: Size in bytes (default: 0)
  /// - [kb]: Size in kilobytes (default: 0)
  /// - [mb]: Size in megabytes (default: 0)
  /// - [gb]: Size in gigabytes (default: 0)
  /// - [tb]: Size in terabytes (default: 0)
  ///
  /// Example:
  /// ```dart
  /// // Create a size of 2 GB + 500 MB + 256 KB
  /// final fileSize = FileSize.units(gb: 2, mb: 500, kb: 256);
  /// print(fileSize.format()); // "2.49 GB"
  /// print(fileSize.inMB); // 2560.25
  ///
  /// // Mixed units for precise sizes
  /// final videoSize = FileSize.units(gb: 1, mb: 750, kb: 512);
  /// print(videoSize.format()); // "1.73 GB"
  ///
  /// // Works with single unit too
  /// final smallFile = FileSize.units(kb: 500);
  /// print(smallFile.format()); // "500.00 KB"
  ///
  /// // Combining bytes with larger units
  /// final precise = FileSize.units(mb: 10, bytes: 1024);
  /// print(precise.inBytes); // 10486272 (10 MB + 1024 bytes)
  /// ```
  ///
  /// Returns a new [FileSize] instance representing the sum of all provided units.
  factory FileSize.units({
    int bytes = 0,
    num kb = 0,
    num mb = 0,
    num gb = 0,
    num tb = 0,
  }) =>
      FileSize.b(
        [
          bytes,
          _strategy.kb.toBytes(kb),
          _strategy.mb.toBytes(mb),
          _strategy.gb.toBytes(gb),
          _strategy.tb.toBytes(tb),
        ].reduce((a, b) => a + b),
      );

  /// Formats the file size as a human-readable string.
  ///
  /// Automatically selects the most appropriate unit based on the size magnitude:
  /// - Less than 1 KB (< 1024 bytes): displays in bytes (B)
  /// - Less than 1 MB (< 1024 KB): displays in kilobytes (KB)
  /// - Less than 1 GB (< 1024 MB): displays in megabytes (MB)
  /// - Less than 1 TB (< 1024 GB): displays in gigabytes (GB)
  /// - 1 TB or more (≥ 1024 GB): displays in terabytes (TB)
  ///
  /// This smart selection ensures the output is always readable and uses
  /// the most meaningful unit for the given size.
  ///
  /// Parameters:
  /// - [fractionDigits]: Number of decimal places to show (default: 2).
  ///   Note: Bytes are always shown as integers without decimals.
  /// - [postfixes]: Optional custom unit labels. If not provided, uses
  ///   the global postfix generator set via [setPostfixesGenerator].
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.kb(1.5);
  /// print(fileSize.format());                    // "1.50 KB"
  /// print(fileSize.format(fractionDigits: 0));   // "2 KB"
  ///
  /// final custom = {'B': 'bytes', 'KB': 'kilobytes', 'MB': 'megabytes', 'GB': 'gigabytes', 'TB': 'terabytes'};
  /// print(fileSize.format(postfixes: custom));   // "1.50 kilobytes"
  /// ```
  ///
  /// Returns a formatted string with the size and appropriate unit.
  String format({int fractionDigits = 2, Map<String, String>? postfixes}) {
    // Use provided postfixes or fall back to the global generator
    postfixes ??= _postfixesGenerator();

    // Select the most appropriate unit based on size
    if (inBytes < _strategy.divider) {
      // Display in bytes (no decimals for byte values)
      return '$inBytes ${postfixes['B']}';
    } else if (inKB < _strategy.divider) {
      // Display in kilobytes
      return '${inKB.toStringAsFixed(fractionDigits)} ${postfixes['KB']}';
    } else if (inMB < _strategy.divider) {
      // Display in megabytes
      return '${inMB.toStringAsFixed(fractionDigits)} ${postfixes['MB']}';
    } else if (inGB < _strategy.divider) {
      // Display in gigabytes
      return '${inGB.toStringAsFixed(fractionDigits)} ${postfixes['GB']}';
    } else {
      // Display in terabytes
      return '${inTB.toStringAsFixed(fractionDigits)} ${postfixes['TB']}';
    }
  }

  /// Sets a global postfix generator for all [FileSize] instances.
  ///
  /// This method allows you to customize the unit labels used when formatting
  /// file sizes across your entire application. It's particularly useful for:
  /// - **Internationalization**: Translating unit labels to different languages
  /// - **Custom branding**: Using company-specific terminology
  /// - **Alternative formats**: Using full names ("bytes") instead of abbreviations ("B")
  ///
  /// Once set, the generator function will be called by [format] whenever
  /// it needs default postfixes (i.e., when no custom postfixes are provided
  /// as a parameter).
  ///
  /// The generator function must return a map containing all five unit keys:
  /// 'B', 'KB', 'MB', 'GB', and 'TB'.
  ///
  /// Example:
  /// ```dart
  /// // Set custom postfixes for internationalization (Spanish)
  /// FileSize.setPostfixesGenerator(() {
  ///   return {
  ///     'B': 'B',
  ///     'KB': 'KB',
  ///     'MB': 'MB',
  ///     'GB': 'GB',
  ///     'TB': 'TB',
  ///   };
  /// });
  ///
  /// // Use full unit names instead of abbreviations
  /// FileSize.setPostfixesGenerator(() {
  ///   return {
  ///     'B': 'bytes',
  ///     'KB': 'kilobytes',
  ///     'MB': 'megabytes',
  ///     'GB': 'gigabytes',
  ///     'TB': 'terabytes',
  ///   };
  /// });
  ///
  /// final fileSize = FileSize.mb(5);
  /// print(fileSize.format()); // "5.00 megabytes" (uses custom postfixes)
  /// ```
  ///
  /// Parameters:
  /// - [generator]: A function that returns a map of unit postfixes.
  ///   The map must contain keys: 'B', 'KB', 'MB', 'GB', 'TB'.
  static void setPostfixesGenerator(Map<String, String> Function() generator) {
    _postfixesGenerator = generator;
  }

  /// The global postfix generator function used for formatting output.
  ///
  /// This function returns a map containing unit label postfixes that are
  /// appended to numerical values when formatting file sizes. By default,
  /// it returns standard English unit labels ('B', 'KB', 'MB', 'GB', 'TB').
  ///
  /// The generator can be customized globally using [setPostfixesGenerator]
  /// to support internationalization, custom branding, or alternative naming
  /// conventions (e.g., "bytes", "kilobytes" instead of "B", "KB").
  ///
  /// Each [format] call uses this generator unless custom postfixes are
  /// explicitly provided as a parameter.
  static Map<String, String> Function() _postfixesGenerator = () {
    return <String, String>{
      'B': 'B',
      'KB': 'KB',
      'MB': 'MB',
      'GB': 'GB',
      'TB': 'TB',
    };
  };

  /// Compares this [FileSize] with another for equality.
  ///
  /// Two [FileSize] instances are equal if they have the same size in bytes.
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.kb(1);
  /// final size2 = FileSize.b(1024);
  /// print(size1 == size2); // true
  /// ```
  @override
  bool operator ==(covariant FileSize other) {
    if (identical(this, other)) return true;
    return other.inBytes == inBytes;
  }

  /// Returns a hash code for this [FileSize].
  ///
  /// The hash code is based on the size in bytes.
  @override
  int get hashCode => inBytes.hashCode;

  /// Compares this [FileSize] with another to determine if it's smaller.
  ///
  /// Returns `true` if this file size is smaller than [other].
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.kb(1);
  /// final size2 = FileSize.mb(1);
  /// print(size1 < size2); // true
  /// ```
  bool operator <(covariant FileSize other) => inBytes < other.inBytes;

  /// Compares this [FileSize] with another to determine if it's smaller or equal.
  ///
  /// Returns `true` if this file size is smaller than or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.kb(1);
  /// final size2 = FileSize.b(1024);
  /// print(size1 <= size2); // true
  /// ```
  bool operator <=(covariant FileSize other) => inBytes <= other.inBytes;

  /// Compares this [FileSize] with another to determine if it's larger.
  ///
  /// Returns `true` if this file size is larger than [other].
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.mb(1);
  /// final size2 = FileSize.kb(1);
  /// print(size1 > size2); // true
  /// ```
  bool operator >(covariant FileSize other) => inBytes > other.inBytes;

  /// Compares this [FileSize] with another to determine if it's larger or equal.
  ///
  /// Returns `true` if this file size is larger than or equal to [other].
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.mb(1);
  /// final size2 = FileSize.b(1048576);
  /// print(size1 >= size2); // true
  /// ```
  bool operator >=(covariant FileSize other) => inBytes >= other.inBytes;

  /// Adds this [FileSize] with another and returns a new [FileSize].
  ///
  /// The result represents the sum of both file sizes.
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.mb(1);
  /// final size2 = FileSize.kb(500);
  /// final total = size1 + size2;
  /// print(total.format()); // "1.49 MB"
  /// ```
  FileSize operator +(covariant FileSize other) => FileSize.b(inBytes + other.inBytes);

  /// Subtracts another [FileSize] from this one and returns a new [FileSize].
  ///
  /// The result represents the difference between the file sizes.
  /// The result will be clamped to 0 if the subtraction would result in negative bytes.
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.mb(2);
  /// final size2 = FileSize.kb(500);
  /// final difference = size1 - size2;
  /// print(difference.format()); // "1.51 MB"
  /// ```
  ///
  /// If the second size is larger than the first, returns [FileSize.b(0)].
  FileSize operator -(covariant FileSize other) {
    final result = inBytes - other.inBytes;
    return FileSize.b(result < 0 ? 0 : result);
  }

  /// Returns a string representation of this [FileSize].
  ///
  /// Uses the default formatting with 2 decimal places.
  ///
  /// Example:
  /// ```dart
  /// final size = FileSize.mb(1.5);
  /// print(size.toString()); // "1.50 MB"
  /// ```
  @override
  String toString() => format();

  /// Compares this [FileSize] with another for ordering.
  ///
  /// Returns a negative integer if this is smaller than [other],
  /// zero if they are equal, and a positive integer if this is larger.
  ///
  /// This method implements [Comparable] interface for better integration
  /// with sorting and collection operations.
  ///
  /// Example:
  /// ```dart
  /// final size1 = FileSize.kb(500);
  /// final size2 = FileSize.mb(1);
  /// print(size1.compareTo(size2)); // Negative (size1 < size2)
  ///
  /// final sizes = [FileSize.gb(1), FileSize.kb(100), FileSize.mb(50)];
  /// sizes.sort(); // Works automatically with Comparable
  /// ```
  @override
  int compareTo(FileSize other) => inBytes.compareTo(other.inBytes);

  /// Multiplies this [FileSize] by a scalar value.
  ///
  /// Returns a new [FileSize] representing the scaled size.
  /// Useful for calculating totals, quotas, or proportions.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.mb(10);
  /// final tripled = fileSize * 3;
  /// print(tripled.format()); // "30.00 MB"
  ///
  /// final half = fileSize * 0.5;
  /// print(half.format()); // "5.00 MB"
  /// ```
  FileSize operator *(covariant num factor) => FileSize.b((inBytes * factor).round());

  /// Divides this [FileSize] by a scalar value.
  ///
  /// Returns a new [FileSize] with the scaled size.
  ///
  /// Example:
  /// ```dart
  /// final fileSize = FileSize.mb(30);
  /// final third = fileSize / 3;
  /// print(third.format()); // "10.00 MB"
  ///
  /// final half = fileSize / 2;
  /// print(half.format()); // "15.00 MB"
  /// ```
  FileSize operator /(covariant num divisor) {
    if (divisor == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return FileSize.b((inBytes / divisor).round());
  }

  /// Calculates the ratio of this [FileSize] to another [FileSize].
  ///
  /// Returns a double representing how many times [other] fits into this size.
  /// Useful for calculating percentages, quotas, and proportions.
  ///
  /// Example:
  /// ```dart
  /// final total = FileSize.gb(1);
  /// final used = FileSize.mb(250);
  /// final ratio = used.ratioTo(total);
  /// print('${(ratio * 100).toStringAsFixed(1)}% used'); // "24.4% used"
  ///
  /// final original = FileSize.mb(100);
  /// final compressed = FileSize.mb(25);
  /// final compressionRatio = compressed.ratioTo(original);
  /// print('Compressed to ${(compressionRatio * 100).toStringAsFixed(0)}%'); // "25%"
  /// ```
  ///
  /// Throws [ArgumentError] if [other] has zero bytes.
  double ratioTo(FileSize other) {
    if (other.inBytes == 0) {
      throw ArgumentError('Cannot calculate ratio with zero bytes');
    }
    return inBytes / other.inBytes;
  }

  /// Returns the smallest [FileSize] from a collection.
  ///
  /// If the list is empty, returns a [FileSize] with zero bytes.
  ///
  /// Example:
  /// ```dart
  /// final files = [
  ///   FileSize.mb(10),
  ///   FileSize.mb(5),
  ///   FileSize.mb(15),
  /// ];
  /// final smallest = FileSize.min(files);
  /// print(smallest.format()); // "5.00 MB"
  /// ```
  static FileSize min(Iterable<FileSize> sizes) {
    if (sizes.isEmpty) return FileSize.zero;
    return sizes.reduce((a, b) => a <= b ? a : b);
  }

  /// Returns the largest [FileSize] from a collection.
  ///
  /// If the list is empty, returns a [FileSize] with zero bytes.
  ///
  /// Example:
  /// ```dart
  /// final files = [
  ///   FileSize.mb(10),
  ///   FileSize.mb(5),
  ///   FileSize.mb(15),
  /// ];
  /// final largest = FileSize.max(files);
  /// print(largest.format()); // "15.00 MB"
  /// ```
  static FileSize max(Iterable<FileSize> sizes) {
    if (sizes.isEmpty) return FileSize.zero;
    return sizes.reduce((a, b) => a >= b ? a : b);
  }

  /// Returns the sum of multiple [FileSize] instances.
  ///
  /// If the list is empty, returns a [FileSize] with zero bytes.
  ///
  /// Example:
  /// ```dart
  /// final files = [
  ///   FileSize.mb(10),
  ///   FileSize.mb(20),
  ///   FileSize.mb(30),
  /// ];
  /// final total = FileSize.sum(files);
  /// print(total.format()); // "60.00 MB"
  /// ```
  static FileSize sum(Iterable<FileSize> sizes) {
    if (sizes.isEmpty) return FileSize.zero;
    return sizes.reduce((a, b) => a + b);
  }

  /// Returns the average of multiple [FileSize] instances.
  ///
  /// If the list is empty, returns a [FileSize] with zero bytes.
  ///
  /// Example:
  /// ```dart
  /// final files = [
  ///   FileSize.mb(10),
  ///   FileSize.mb(20),
  ///   FileSize.mb(30),
  /// ];
  /// final avg = FileSize.average(files);
  /// print(avg.format()); // "20.00 MB"
  /// ```
  static FileSize average(Iterable<FileSize> sizes) {
    if (sizes.isEmpty) return FileSize.zero;
    final total = sum(sizes);
    return FileSize.b((total.inBytes / sizes.length).round());
  }
}
