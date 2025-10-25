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

export 'src/sized_file.dart';
export 'src/extension.dart';
