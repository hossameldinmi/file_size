import 'dart:math';

class FileSize {
  static const int _divider = 1024;
  FileSize.b(this.inBytes)
    : assert(inBytes >= 0),
      inKB = inBytes / _divider,
      inMB = inBytes / pow(_divider, 2),
      inGB = inBytes / pow(_divider, 3);
  final int inBytes;
  final double inKB;
  final double inMB;
  final double inGB;

  FileSize.kb(double inKB) : this.b((inKB * _divider).toInt());
  FileSize.mb(double inMB) : this.b((inMB * pow(_divider, 2)).toInt());
  FileSize.gb(double inGB) : this.b((inGB * pow(_divider, 3)).toInt());
  FileSize.tb(double inTB) : this.b((inTB * pow(_divider, 4)).toInt());

  String format({int fractionDigits = 2, Map<String, String>? postfixes}) {
    postfixes ??= _postfixesGenerator();
    if (inBytes < _divider) {
      return '$inBytes ${postfixes['B']}';
    } else if (inKB < _divider) {
      return '${inKB.toStringAsFixed(fractionDigits)} ${postfixes['KB']}';
    } else if (inMB < _divider) {
      return '${inMB.toStringAsFixed(fractionDigits)} ${postfixes['MB']}';
    } else {
      return '${inGB.toStringAsFixed(fractionDigits)} ${postfixes['GB']}';
    }
  }

  static void setPostfixesGenerator(Map<String, String> Function() generator) {
    _postfixesGenerator = generator;
  }

  static Map<String, String> Function() _postfixesGenerator = () {
    return <String, String>{'B': 'B', 'KB': 'KB', 'MB': 'MB', 'GB': 'GB', 'TB': 'TB'};
  };
}
