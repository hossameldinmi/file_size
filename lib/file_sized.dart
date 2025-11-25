/// A lightweight Dart library for handling file size conversions and formatting.
///
/// This library provides the [FileSize] class for easy file size manipulation
/// across different units (bytes, KB, MB, GB, TB) with support for custom
/// formatting and internationalization.
///
/// Example usage:
/// ```dart
/// import 'package:file_sized/file_sized.dart';
///
/// void main() {
///   final fileSize = FileSize.mb(5);
///   print(fileSize.format()); // "5.00 MB"
///   print(fileSize.inBytes);  // 5242880
/// }
/// ```
library file_sized;

export 'src/file_size.dart';
export 'src/extensions.dart';
