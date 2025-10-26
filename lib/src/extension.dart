import 'package:sized_file/sized_file.dart';

/// Convenient extension methods on [num] for creating [SizedFile] instances.
///
/// These extensions provide syntactic sugar for creating file size objects
/// using intuitive notation like `5.mb` or `1.gb`, making code more readable
/// and expressive.
///
/// All extensions work with both [int] and [double] values, though the [b]
/// extension converts to integer bytes automatically.
///
/// Example:
/// ```dart
/// final document = 500.kb;        // 500 kilobytes
/// final video = 1.5.gb;           // 1.5 gigabytes
/// final total = 2.mb + 512.kb;    // 2.5 megabytes
/// final small = 1024.b;           // 1024 bytes
/// ```
extension NumericExtensions on num {
  /// Converts the number to a [SizedFile] representing bytes.
  ///
  /// The value is automatically converted to an integer, truncating any
  /// decimal places. This ensures byte counts are always whole numbers.
  ///
  /// Example:
  /// ```dart
  /// final size1 = 1024.b;      // 1024 bytes
  /// final size2 = 1500.5.b;    // 1500 bytes (truncated)
  /// print(size1.inKB);         // 1.0
  /// ```
  SizedFile get b => SizedFile.b(this.toInt());

  /// Converts the number to a [SizedFile] representing kilobytes.
  ///
  /// Supports both integer and decimal values for precise size specification.
  ///
  /// Example:
  /// ```dart
  /// final size1 = 10.kb;       // 10 KB = 10,240 bytes
  /// final size2 = 1.5.kb;      // 1.5 KB = 1,536 bytes
  /// print(size1.inBytes);      // 10240
  /// ```
  SizedFile get kb => SizedFile.kb(this);

  /// Converts the number to a [SizedFile] representing megabytes.
  ///
  /// Supports both integer and decimal values for precise size specification.
  ///
  /// Example:
  /// ```dart
  /// final image = 2.5.mb;      // 2.5 MB = 2,621,440 bytes
  /// final document = 5.mb;     // 5 MB = 5,242,880 bytes
  /// print(image.inKB);         // 2560.0
  /// ```
  SizedFile get mb => SizedFile.mb(this);

  /// Converts the number to a [SizedFile] representing gigabytes.
  ///
  /// Supports both integer and decimal values for precise size specification.
  ///
  /// Example:
  /// ```dart
  /// final video = 1.5.gb;      // 1.5 GB = 1,610,612,736 bytes
  /// final game = 50.gb;        // 50 GB
  /// print(video.inMB);         // 1536.0
  /// ```
  SizedFile get gb => SizedFile.gb(this);

  /// Converts the number to a [SizedFile] representing terabytes.
  ///
  /// Supports both integer and decimal values for precise size specification.
  ///
  /// Example:
  /// ```dart
  /// final backup = 2.tb;       // 2 TB = 2,199,023,255,552 bytes
  /// final archive = 0.5.tb;    // 0.5 TB = 512 GB
  /// print(backup.inGB);        // 2048.0
  /// ```
  SizedFile get tb => SizedFile.tb(this);
}
