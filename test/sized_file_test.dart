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

  group('SizedFile equality operations', () {
    test('equality operator works with same sizes in different units', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0);
      final size3 = SizedFile.mb(0.0009765625);

      expect(size1 == size2, isTrue);
      expect(size2 == size3, isTrue);
      expect(size1 == size3, isTrue);
    });

    test('equality operator works with identical instances', () {
      final size = SizedFile.mb(5);
      expect(size == size, isTrue);
    });

    test('equality operator returns false for different sizes', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.kb(2);

      expect(size1 == size2, isFalse);
    });

    test('equality operator works with zero bytes', () {
      final size1 = SizedFile.b(0);
      final size2 = SizedFile.kb(0);
      final size3 = SizedFile.mb(0);

      expect(size1 == size2, isTrue);
      expect(size2 == size3, isTrue);
      expect(size1 == size3, isTrue);
    });

    test('hashCode is consistent with equality', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0);

      expect(size1 == size2, isTrue);
      expect(size1.hashCode, equals(size2.hashCode));
    });

    test('hashCode is different for different sizes', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.kb(2);

      expect(size1.hashCode, isNot(equals(size2.hashCode)));
    });

    test('objects work correctly in Set collections', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0); // Same as size1
      final size3 = SizedFile.kb(2.0);

      final sizeSet = <SizedFile>{size1, size2, size3};

      expect(sizeSet.length, equals(2)); // size1 and size2 are equal
      expect(sizeSet.contains(SizedFile.b(1024)), isTrue);
      expect(sizeSet.contains(SizedFile.kb(2.0)), isTrue);
      expect(sizeSet.contains(SizedFile.kb(3.0)), isFalse);
    });

    test('objects work correctly in Map keys', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0); // Same as size1

      final sizeMap = <SizedFile, String>{
        size1: 'first',
        size2: 'second', // Should overwrite 'first'
        SizedFile.kb(2.0): 'third',
      };

      expect(sizeMap.length, equals(2));
      expect(sizeMap[SizedFile.b(1024)], equals('second'));
      expect(sizeMap[SizedFile.kb(2.0)], equals('third'));
    });
  });

  group('SizedFile comparison operations', () {
    test('less than operator works correctly', () {
      final smaller = SizedFile.kb(1);
      final larger = SizedFile.mb(1);

      expect(smaller < larger, isTrue);
      expect(larger < smaller, isFalse);
    });

    test('less than or equal operator works correctly', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.b(1024); // Same as size1
      final size3 = SizedFile.mb(1);

      expect(size1 <= size2, isTrue); // Equal
      expect(size1 <= size3, isTrue); // Less than
      expect(size3 <= size1, isFalse); // Greater than
    });

    test('greater than operator works correctly', () {
      final smaller = SizedFile.kb(1);
      final larger = SizedFile.mb(1);

      expect(larger > smaller, isTrue);
      expect(smaller > larger, isFalse);
    });

    test('greater than or equal operator works correctly', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.b(1024); // Same as size1
      final size3 = SizedFile.mb(1);

      expect(size1 >= size2, isTrue); // Equal
      expect(size3 >= size1, isTrue); // Greater than
      expect(size1 >= size3, isFalse); // Less than
    });

    test('comparison with zero bytes', () {
      final zero = SizedFile.b(0);
      final nonZero = SizedFile.b(1);

      expect(zero < nonZero, isTrue);
      expect(zero <= nonZero, isTrue);
      expect(nonZero > zero, isTrue);
      expect(nonZero >= zero, isTrue);
      expect(zero >= zero, isTrue);
      expect(zero <= zero, isTrue);
    });

    test('comparison across different units', () {
      final bytes = SizedFile.b(500);
      final kilobytes = SizedFile.kb(1); // 1024 bytes
      final megabytes = SizedFile.mb(1); // 1048576 bytes
      final gigabytes = SizedFile.gb(1); // 1073741824 bytes

      expect(bytes < kilobytes, isTrue);
      expect(kilobytes < megabytes, isTrue);
      expect(megabytes < gigabytes, isTrue);

      expect(gigabytes > megabytes, isTrue);
      expect(megabytes > kilobytes, isTrue);
      expect(kilobytes > bytes, isTrue);
    });

    test('comparison transitivity', () {
      final small = SizedFile.kb(1);
      final medium = SizedFile.mb(1);
      final large = SizedFile.gb(1);

      // Transitivity: if a < b and b < c, then a < c
      expect(small < medium, isTrue);
      expect(medium < large, isTrue);
      expect(small < large, isTrue);
    });

    test('sorting works correctly', () {
      final sizes = [
        SizedFile.gb(1),
        SizedFile.b(500),
        SizedFile.mb(100),
        SizedFile.kb(750),
      ];

      sizes.sort((a, b) => a.inBytes.compareTo(b.inBytes));

      expect(sizes[0].inBytes, equals(500)); // 500 B
      expect(sizes[1].inBytes, equals(768000)); // 750 KB
      expect(sizes[2].inBytes, equals(104857600)); // 100 MB
      expect(sizes[3].inBytes, equals(1073741824)); // 1 GB
    });

    test('comparison with identical values', () {
      final size1 = SizedFile.mb(5);
      final size2 = SizedFile.mb(5);

      expect(size1 <= size2, isTrue);
      expect(size1 >= size2, isTrue);
      expect(size1 < size2, isFalse);
      expect(size1 > size2, isFalse);
    });
  });

  group('SizedFile toString operation', () {
    test('toString returns formatted string', () {
      final size = SizedFile.mb(1.5);
      expect(size.toString(), equals('1.50 MB'));
    });

    test('toString works with different sizes', () {
      expect(SizedFile.b(500).toString(), equals('500 B'));
      expect(SizedFile.kb(2.5).toString(), equals('2.50 KB'));
      expect(SizedFile.gb(1.25).toString(), equals('1.25 GB'));
    });

    test('toString works with zero', () {
      expect(SizedFile.b(0).toString(), equals('0 B'));
    });
  });
}
