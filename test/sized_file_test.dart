import 'package:test/test.dart';
import 'package:sized_file/sized_file.dart';

void main() {
  group('SizedFile constructors', () {
    test('SizedFile.b creates instance with bytes', () {
      final fileSize = SizedFile.b(1024);
      expect(fileSize.inBytes, equals(1024));
      expect(fileSize.inKB, equals(1.0));
      expect(fileSize.inMB, closeTo(0.0009765625, 0.0001));
      expect(fileSize.inGB, closeTo(9.5367431640625e-7, 0.0000001));
    });

    test('SizedFile.b with zero bytes', () {
      final fileSize = SizedFile.b(0);
      expect(fileSize.inBytes, equals(0));
      expect(fileSize.inKB, equals(0.0));
      expect(fileSize.inMB, equals(0.0));
      expect(fileSize.inGB, equals(0.0));
    });

    test('SizedFile.kb creates instance from kilobytes', () {
      final fileSize = SizedFile.kb(1.0);
      expect(fileSize.inBytes, equals(1024));
      expect(fileSize.inKB, equals(1.0));
    });

    test('SizedFile.mb creates instance from megabytes', () {
      final fileSize = SizedFile.mb(1.0);
      expect(fileSize.inBytes, equals(1048576));
      expect(fileSize.inMB, equals(1.0));
      expect(fileSize.inKB, equals(1024.0));
    });

    test('SizedFile.gb creates instance from gigabytes', () {
      final fileSize = SizedFile.gb(1.0);
      expect(fileSize.inBytes, equals(1073741824));
      expect(fileSize.inGB, equals(1.0));
      expect(fileSize.inMB, equals(1024.0));
      expect(fileSize.inKB, equals(1048576.0));
    });

    test('SizedFile.tb creates instance from terabytes', () {
      final fileSize = SizedFile.tb(1.0);
      expect(fileSize.inBytes, equals(1099511627776));
      expect(fileSize.inGB, equals(1024.0));
    });

    test('SizedFile.b throws assertion error for negative bytes', () {
      expect(() => SizedFile.b(-1), throwsA(isA<AssertionError>()));
    });
  });

  group('SizedFile.format', () {
    test('formats bytes correctly', () {
      final fileSize = SizedFile.b(512);
      expect(fileSize.format(), equals('512 B'));
    });

    test('formats kilobytes correctly', () {
      final fileSize = SizedFile.kb(1.5);
      expect(fileSize.format(), equals('1.50 KB'));
    });

    test('formats megabytes correctly', () {
      final fileSize = SizedFile.mb(2.5);
      expect(fileSize.format(), equals('2.50 MB'));
    });

    test('formats gigabytes correctly', () {
      final fileSize = SizedFile.gb(3.75);
      expect(fileSize.format(), equals('3.75 GB'));
    });

    test('formats with custom fraction digits', () {
      final fileSize = SizedFile.kb(1.5);
      expect(fileSize.format(fractionDigits: 0), equals('2 KB'));
      expect(fileSize.format(fractionDigits: 1), equals('1.5 KB'));
      expect(fileSize.format(fractionDigits: 3), equals('1.500 KB'));
    });

    test('formats with custom postfixes', () {
      final fileSize = SizedFile.kb(1.5);
      final customPostfixes = {
        'B': 'bytes',
        'KB': 'kilobytes',
        'MB': 'megabytes',
        'GB': 'gigabytes',
        'TB': 'terabytes',
      };
      expect(
        fileSize.format(postfixes: customPostfixes),
        equals('1.50 kilobytes'),
      );
    });

    test('formats bytes without fraction digits', () {
      final fileSize = SizedFile.b(100);
      expect(fileSize.format(), equals('100 B'));
    });

    test('formats at KB boundary', () {
      final fileSize = SizedFile.b(1024);
      expect(fileSize.format(), equals('1.00 KB'));
    });

    test('formats at MB boundary', () {
      final fileSize = SizedFile.b(1048576);
      expect(fileSize.format(), equals('1.00 MB'));
    });

    test('formats at GB boundary', () {
      final fileSize = SizedFile.b(1073741824);
      expect(fileSize.format(), equals('1.00 GB'));
    });

    test('formats large GB values', () {
      final fileSize = SizedFile.gb(1500.5);
      expect(fileSize.format(), equals('1500.50 GB'));
    });
  });

  group('SizedFile.setPostfixesGenerator', () {
    tearDown(() {
      // Reset to default postfixes after each test
      SizedFile.setPostfixesGenerator(() {
        return <String, String>{
          'B': 'B',
          'KB': 'KB',
          'MB': 'MB',
          'GB': 'GB',
          'TB': 'TB',
        };
      });
    });

    test('allows setting custom postfix generator', () {
      SizedFile.setPostfixesGenerator(() {
        return <String, String>{
          'B': 'Bytes',
          'KB': 'Kilobytes',
          'MB': 'Megabytes',
          'GB': 'Gigabytes',
          'TB': 'Terabytes',
        };
      });
      final fileSize = SizedFile.kb(1.0);
      expect(fileSize.format(), equals('1.00 Kilobytes'));
    });

    test('custom postfix generator affects all instances', () {
      SizedFile.setPostfixesGenerator(() {
        return <String, String>{
          'B': 'b',
          'KB': 'kb',
          'MB': 'mb',
          'GB': 'gb',
          'TB': 'tb',
        };
      });
      final fileSize1 = SizedFile.b(100);
      final fileSize2 = SizedFile.mb(1.0);
      expect(fileSize1.format(), equals('100 b'));
      expect(fileSize2.format(), equals('1.00 mb'));
    });
  });

  group('SizedFile edge cases', () {
    test('handles very large byte values', () {
      final fileSize = SizedFile.b(999999999999);
      expect(fileSize.inBytes, equals(999999999999));
      expect(fileSize.format(), contains('GB'));
    });

    test('handles fractional KB input', () {
      final fileSize = SizedFile.kb(0.5);
      expect(fileSize.inBytes, equals(512));
    });

    test('handles fractional MB input', () {
      final fileSize = SizedFile.mb(0.5);
      expect(fileSize.inBytes, equals(524288));
    });

    test('handles fractional GB input', () {
      final fileSize = SizedFile.gb(0.5);
      expect(fileSize.inBytes, equals(536870912));
    });

    test('handles small values just under KB threshold', () {
      final fileSize = SizedFile.b(1023);
      expect(fileSize.format(), equals('1023 B'));
    });

    test('handles values just under MB threshold', () {
      final fileSize = SizedFile.b(1048575);
      expect(fileSize.format(), contains('KB'));
    });

    test('handles values just under GB threshold', () {
      final fileSize = SizedFile.b(1073741823);
      expect(fileSize.format(), contains('MB'));
    });
  });

  group('SizedFile conversions', () {
    test('1 KB equals 1024 bytes', () {
      final fileSize = SizedFile.kb(1.0);
      expect(fileSize.inBytes, equals(1024));
    });

    test('1 MB equals 1024 KB', () {
      final fileSize = SizedFile.mb(1.0);
      expect(fileSize.inKB, equals(1024.0));
    });

    test('1 GB equals 1024 MB', () {
      final fileSize = SizedFile.gb(1.0);
      expect(fileSize.inMB, equals(1024.0));
    });

    test('1 TB equals 1024 GB', () {
      final fileSize = SizedFile.tb(1.0);
      expect(fileSize.inGB, equals(1024.0));
    });

    test('conversion consistency', () {
      final bytesValue = 5242880; // 5 MB
      final fromBytes = SizedFile.b(bytesValue);
      final fromKB = SizedFile.kb(fromBytes.inKB);
      final fromMB = SizedFile.mb(fromBytes.inMB);
      final fromGB = SizedFile.gb(fromBytes.inGB);

      expect(fromKB.inBytes, equals(bytesValue));
      expect(fromMB.inBytes, equals(bytesValue));
      expect(fromGB.inBytes, equals(bytesValue));
    });
  });
}
