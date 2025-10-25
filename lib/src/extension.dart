import 'package:sized_file/sized_file.dart';

extension numericExtensions on num {
  /// Converts the number to a [SizedFile] in bytes.
  SizedFile get b => SizedFile.b(this.toInt());

  /// Converts the number to a [SizedFile] in kilobytes.
  SizedFile get kb => SizedFile.kb(this);

  /// Converts the number to a [SizedFile] in megabytes.
  SizedFile get mb => SizedFile.mb(this);

  /// Converts the number to a [SizedFile] in gigabytes.
  SizedFile get gb => SizedFile.gb(this);

  /// Converts the number to a [SizedFile] in terabytes.
  SizedFile get tb => SizedFile.tb(this);
}
