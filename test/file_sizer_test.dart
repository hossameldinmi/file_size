import 'package:flutter_test/flutter_test.dart';
import 'package:file_size/file_size.dart';

void main() {
  group('FileSize constructors', () {
    test('FileSize.b creates instance with bytes', () {
      final fileSize = FileSize.b(1024);
      expect(fileSize.inBytes, equals(1024));
      expect(fileSize.inKB, equals(1.0));
      expect(fileSize.inMB, closeTo(0.0009765625, 0.0001));
      expect(fileSize.inGB, closeTo(9.5367431640625e-7, 0.0000001));
    });

    test('FileSize.b with zero bytes', () {
      final fileSize = FileSize.b(0);
      expect(fileSize.inBytes, equals(0));
      expect(fileSize.inKB, equals(0.0));
      expect(fileSize.inMB, equals(0.0));
      expect(fileSize.inGB, equals(0.0));
    });

    test('FileSize.kb creates instance from kilobytes', () {
      final fileSize = FileSize.kb(1.0);
      expect(fileSize.inBytes, equals(1024));
      expect(fileSize.inKB, equals(1.0));
    });

    test('FileSize.mb creates instance from megabytes', () {
      final fileSize = FileSize.mb(1.0);
      expect(fileSize.inBytes, equals(1048576));
      expect(fileSize.inMB, equals(1.0));
      expect(fileSize.inKB, equals(1024.0));
    });

    test('FileSize.gb creates instance from gigabytes', () {
      final fileSize = FileSize.gb(1.0);
      expect(fileSize.inBytes, equals(1073741824));
      expect(fileSize.inGB, equals(1.0));
      expect(fileSize.inMB, equals(1024.0));
      expect(fileSize.inKB, equals(1048576.0));
    });

    test('FileSize.tb creates instance from terabytes', () {
      final fileSize = FileSize.tb(1.0);
      expect(fileSize.inBytes, equals(1099511627776));
      expect(fileSize.inGB, equals(1024.0));
    });

    test('FileSize.b throws assertion error for negative bytes', () {
      expect(() => FileSize.b(-1), throwsA(isA<AssertionError>()));
    });
  });

  group('FileSize.format', () {
    test('formats bytes correctly', () {
      final fileSize = FileSize.b(512);
      expect(fileSize.format(), equals('512 B'));
    });

    test('formats kilobytes correctly', () {
      final fileSize = FileSize.kb(1.5);
      expect(fileSize.format(), equals('1.50 KB'));
    });

    test('formats megabytes correctly', () {
      final fileSize = FileSize.mb(2.5);
      expect(fileSize.format(), equals('2.50 MB'));
    });

    test('formats gigabytes correctly', () {
      final fileSize = FileSize.gb(3.75);
      expect(fileSize.format(), equals('3.75 GB'));
    });

    test('formats with custom fraction digits', () {
      final fileSize = FileSize.kb(1.5);
      expect(fileSize.format(fractionDigits: 0), equals('2 KB'));
      expect(fileSize.format(fractionDigits: 1), equals('1.5 KB'));
      expect(fileSize.format(fractionDigits: 3), equals('1.500 KB'));
    });

    test('formats with custom postfixes', () {
      final fileSize = FileSize.kb(1.5);
      final customPostfixes = {
        'B': 'bytes',
        'KB': 'kilobytes',
        'MB': 'megabytes',
        'GB': 'gigabytes',
        'TB': 'terabytes',
      };
      expect(fileSize.format(postfixes: customPostfixes), equals('1.50 kilobytes'));
    });

    test('formats bytes without fraction digits', () {
      final fileSize = FileSize.b(100);
      expect(fileSize.format(), equals('100 B'));
    });

    test('formats at KB boundary', () {
      final fileSize = FileSize.b(1024);
      expect(fileSize.format(), equals('1.00 KB'));
    });

    test('formats at MB boundary', () {
      final fileSize = FileSize.b(1048576);
      expect(fileSize.format(), equals('1.00 MB'));
    });

    test('formats at GB boundary', () {
      final fileSize = FileSize.b(1073741824);
      expect(fileSize.format(), equals('1.00 GB'));
    });

    test('formats large GB values', () {
      final fileSize = FileSize.gb(1500.5);
      expect(fileSize.format(), equals('1500.50 GB'));
    });
  });

  group('FileSize.setPostfixesGenerator', () {
    tearDown(() {
      // Reset to default postfixes after each test
      FileSize.setPostfixesGenerator(() {
        return <String, String>{'B': 'B', 'KB': 'KB', 'MB': 'MB', 'GB': 'GB', 'TB': 'TB'};
      });
    });

    test('allows setting custom postfix generator', () {
      FileSize.setPostfixesGenerator(() {
        return <String, String>{
          'B': 'Bytes',
          'KB': 'Kilobytes',
          'MB': 'Megabytes',
          'GB': 'Gigabytes',
          'TB': 'Terabytes',
        };
      });
      final fileSize = FileSize.kb(1.0);
      expect(fileSize.format(), equals('1.00 Kilobytes'));
    });

    test('custom postfix generator affects all instances', () {
      FileSize.setPostfixesGenerator(() {
        return <String, String>{'B': 'b', 'KB': 'kb', 'MB': 'mb', 'GB': 'gb', 'TB': 'tb'};
      });
      final fileSize1 = FileSize.b(100);
      final fileSize2 = FileSize.mb(1.0);
      expect(fileSize1.format(), equals('100 b'));
      expect(fileSize2.format(), equals('1.00 mb'));
    });
  });

  group('FileSize edge cases', () {
    test('handles very large byte values', () {
      final fileSize = FileSize.b(999999999999);
      expect(fileSize.inBytes, equals(999999999999));
      expect(fileSize.format(), contains('GB'));
    });

    test('handles fractional KB input', () {
      final fileSize = FileSize.kb(0.5);
      expect(fileSize.inBytes, equals(512));
    });

    test('handles fractional MB input', () {
      final fileSize = FileSize.mb(0.5);
      expect(fileSize.inBytes, equals(524288));
    });

    test('handles fractional GB input', () {
      final fileSize = FileSize.gb(0.5);
      expect(fileSize.inBytes, equals(536870912));
    });

    test('handles small values just under KB threshold', () {
      final fileSize = FileSize.b(1023);
      expect(fileSize.format(), equals('1023 B'));
    });

    test('handles values just under MB threshold', () {
      final fileSize = FileSize.b(1048575);
      expect(fileSize.format(), contains('KB'));
    });

    test('handles values just under GB threshold', () {
      final fileSize = FileSize.b(1073741823);
      expect(fileSize.format(), contains('MB'));
    });
  });

  group('FileSize conversions', () {
    test('1 KB equals 1024 bytes', () {
      final fileSize = FileSize.kb(1.0);
      expect(fileSize.inBytes, equals(1024));
    });

    test('1 MB equals 1024 KB', () {
      final fileSize = FileSize.mb(1.0);
      expect(fileSize.inKB, equals(1024.0));
    });

    test('1 GB equals 1024 MB', () {
      final fileSize = FileSize.gb(1.0);
      expect(fileSize.inMB, equals(1024.0));
    });

    test('1 TB equals 1024 GB', () {
      final fileSize = FileSize.tb(1.0);
      expect(fileSize.inGB, equals(1024.0));
    });

    test('conversion consistency', () {
      final bytesValue = 5242880; // 5 MB
      final fromBytes = FileSize.b(bytesValue);
      final fromKB = FileSize.kb(fromBytes.inKB);
      final fromMB = FileSize.mb(fromBytes.inMB);
      final fromGB = FileSize.gb(fromBytes.inGB);

      expect(fromKB.inBytes, equals(bytesValue));
      expect(fromMB.inBytes, equals(bytesValue));
      expect(fromGB.inBytes, equals(bytesValue));
    });
  });
}
