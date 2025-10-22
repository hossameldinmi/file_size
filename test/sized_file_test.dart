import 'package:test/test.dart';
import 'package:sized_file/sized_file.dart';

void main() {
  group('SizedFile constructors', () {
    test('SizedFile.zero creates instance with zero bytes', () {
      final fileSize = SizedFile.zero;
      expect(fileSize.inBytes, 0);
      expect(fileSize.inKB, 0.0);
      expect(fileSize.inMB, 0.0);
      expect(fileSize.inGB, 0.0);
    });

    test('SizedFile.b creates instance with bytes', () {
      final fileSize = SizedFile.b(1024);
      expect(fileSize.inBytes, 1024);
      expect(fileSize.inKB, 1.0);
      expect(fileSize.inMB, closeTo(0.0009765625, 0.0001));
      expect(fileSize.inGB, closeTo(9.5367431640625e-7, 0.0000001));
    });

    test('SizedFile.b with zero bytes', () {
      final fileSize = SizedFile.b(0);
      expect(fileSize.inBytes, 0);
      expect(fileSize.inKB, 0.0);
      expect(fileSize.inMB, 0.0);
      expect(fileSize.inGB, 0.0);
    });

    test('SizedFile.kb creates instance from kilobytes', () {
      final fileSize = SizedFile.kb(1.0);
      expect(fileSize.inBytes, 1024);
      expect(fileSize.inKB, 1.0);
    });

    test('SizedFile.mb creates instance from megabytes', () {
      final fileSize = SizedFile.mb(1.0);
      expect(fileSize.inBytes, 1048576);
      expect(fileSize.inMB, 1.0);
      expect(fileSize.inKB, 1024.0);
    });

    test('SizedFile.gb creates instance from gigabytes', () {
      final fileSize = SizedFile.gb(1.0);
      expect(fileSize.inBytes, 1073741824);
      expect(fileSize.inGB, 1.0);
      expect(fileSize.inMB, 1024.0);
      expect(fileSize.inKB, 1048576.0);
    });

    test('SizedFile.tb creates instance from terabytes', () {
      final fileSize = SizedFile.tb(1.0);
      expect(fileSize.inBytes, 1099511627776);
      expect(fileSize.inGB, 1024.0);
    });

    test('SizedFile.b throws assertion error for negative bytes', () {
      expect(() => SizedFile.b(-1), throwsA(isA<AssertionError>()));
    });

    test('SizedFile.values creates instance from mixed units', () {
      final fileSize = SizedFile.values(gb: 2, mb: 500, kb: 256);
      // 2 GB = 2147483648 bytes
      // 500 MB = 524288000 bytes
      // 256 KB = 262144 bytes
      // Total = 2672033792 bytes
      expect(fileSize.inBytes, 2672033792);
      expect(fileSize.inGB, closeTo(2.48828125, 0.001));
    });

    test('SizedFile.values with single unit', () {
      final fileSize = SizedFile.values(mb: 10);
      expect(fileSize.inBytes, 10485760);
      expect(fileSize.inMB, 10.0);
    });

    test('SizedFile.values with all units', () {
      final fileSize = SizedFile.values(
        tb: 1,
        gb: 2,
        mb: 500,
        kb: 256,
        bytes: 1024,
      );
      // 1 TB = 1099511627776 bytes
      // 2 GB = 2147483648 bytes
      // 500 MB = 524288000 bytes
      // 256 KB = 262144 bytes
      // 1024 bytes = 1024 bytes
      // Total = 1102183662592 bytes
      expect(fileSize.inBytes, 1102183662592);
    });

    test('SizedFile.values with bytes and larger units', () {
      final fileSize = SizedFile.values(mb: 10, bytes: 1024);
      expect(fileSize.inBytes, 10486784); // 10 MB + 1024 bytes
    });

    test('SizedFile.values with all zeros returns zero', () {
      final fileSize = SizedFile.values();
      expect(fileSize.inBytes, 0);
      expect(fileSize == SizedFile.zero, true);
    });

    test('SizedFile.values with only bytes', () {
      final fileSize = SizedFile.values(bytes: 2048);
      expect(fileSize.inBytes, 2048);
      expect(fileSize.inKB, 2.0);
    });

    test('SizedFile.values with decimal values', () {
      final fileSize = SizedFile.values(gb: 1.5, mb: 250.5);
      expect(fileSize.inGB, closeTo(1.744628906, 0.001));
    });

    test('SizedFile.values ignores zero values efficiently', () {
      final fileSize1 = SizedFile.values(gb: 1, mb: 0, kb: 0);
      final fileSize2 = SizedFile.gb(1);
      expect(fileSize1 == fileSize2, true);
    });
  });

  group('SizedFile.format', () {
    test('formats bytes correctly', () {
      final fileSize = SizedFile.b(512);
      expect(fileSize.format(), '512 B');
    });

    test('formats kilobytes correctly', () {
      final fileSize = SizedFile.kb(1.5);
      expect(fileSize.format(), '1.50 KB');
    });

    test('formats megabytes correctly', () {
      final fileSize = SizedFile.mb(2.5);
      expect(fileSize.format(), '2.50 MB');
    });

    test('formats gigabytes correctly', () {
      final fileSize = SizedFile.gb(3.75);
      expect(fileSize.format(), '3.75 GB');
    });

    test('formats with custom fraction digits', () {
      final fileSize = SizedFile.kb(1.5);
      expect(fileSize.format(fractionDigits: 0), '2 KB');
      expect(fileSize.format(fractionDigits: 1), '1.5 KB');
      expect(fileSize.format(fractionDigits: 3), '1.500 KB');
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
        '1.50 kilobytes',
      );
    });

    test('formats bytes without fraction digits', () {
      final fileSize = SizedFile.b(100);
      expect(fileSize.format(), '100 B');
    });

    test('formats at KB boundary', () {
      final fileSize = SizedFile.b(1024);
      expect(fileSize.format(), '1.00 KB');
    });

    test('formats at MB boundary', () {
      final fileSize = SizedFile.b(1048576);
      expect(fileSize.format(), '1.00 MB');
    });

    test('formats at GB boundary', () {
      final fileSize = SizedFile.b(1073741824);
      expect(fileSize.format(), '1.00 GB');
    });

    test('formats large GB values', () {
      final fileSize = SizedFile.gb(1500.5);
      expect(fileSize.format(), '1500.50 GB');
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
      expect(fileSize.format(), '1.00 Kilobytes');
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
      expect(fileSize1.format(), '100 b');
      expect(fileSize2.format(), '1.00 mb');
    });
  });

  group('SizedFile edge cases', () {
    test('handles very large byte values', () {
      final fileSize = SizedFile.b(999999999999);
      expect(fileSize.inBytes, 999999999999);
      expect(fileSize.format(), contains('GB'));
    });

    test('handles fractional KB input', () {
      final fileSize = SizedFile.kb(0.5);
      expect(fileSize.inBytes, 512);
    });

    test('handles fractional MB input', () {
      final fileSize = SizedFile.mb(0.5);
      expect(fileSize.inBytes, 524288);
    });

    test('handles fractional GB input', () {
      final fileSize = SizedFile.gb(0.5);
      expect(fileSize.inBytes, 536870912);
    });

    test('handles small values just under KB threshold', () {
      final fileSize = SizedFile.b(1023);
      expect(fileSize.format(), '1023 B');
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
      expect(fileSize.inBytes, 1024);
    });

    test('1 MB equals 1024 KB', () {
      final fileSize = SizedFile.mb(1.0);
      expect(fileSize.inKB, 1024.0);
    });

    test('1 GB equals 1024 MB', () {
      final fileSize = SizedFile.gb(1.0);
      expect(fileSize.inMB, 1024.0);
    });

    test('1 TB equals 1024 GB', () {
      final fileSize = SizedFile.tb(1.0);
      expect(fileSize.inGB, 1024.0);
    });

    test('conversion consistency', () {
      final bytesValue = 5242880; // 5 MB
      final fromBytes = SizedFile.b(bytesValue);
      final fromKB = SizedFile.kb(fromBytes.inKB);
      final fromMB = SizedFile.mb(fromBytes.inMB);
      final fromGB = SizedFile.gb(fromBytes.inGB);

      expect(fromKB.inBytes, bytesValue);
      expect(fromMB.inBytes, bytesValue);
      expect(fromGB.inBytes, bytesValue);
    });
  });

  group('SizedFile equality operations', () {
    test('equality operator works with same sizes in different units', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0);
      final size3 = SizedFile.mb(0.0009765625);

      expect(size1 == size2, true);
      expect(size2 == size3, true);
      expect(size1 == size3, true);
    });

    test('equality operator works with identical instances', () {
      final size = SizedFile.mb(5);
      expect(size == size, true);
    });

    test('equality operator returns false for different sizes', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.kb(2);

      expect(size1 == size2, false);
    });

    test('equality operator works with zero bytes', () {
      final size1 = SizedFile.b(0);
      final size2 = SizedFile.kb(0);
      final size3 = SizedFile.mb(0);

      expect(size1 == size2, true);
      expect(size2 == size3, true);
      expect(size1 == size3, true);
    });

    test('hashCode is consistent with equality', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0);

      expect(size1 == size2, true);
      expect(size1.hashCode, size2.hashCode);
    });

    test('hashCode is different for different sizes', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.kb(2);

      expect(size1.hashCode, isNot(size2.hashCode));
    });

    test('objects work correctly in Set collections', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0); // Same as size1
      final size3 = SizedFile.kb(2.0);

      final sizeSet = <SizedFile>{size1, size2, size3};

      expect(sizeSet.length, 2); // size1 and size2 are equal
      expect(sizeSet.contains(SizedFile.b(1024)), true);
      expect(sizeSet.contains(SizedFile.kb(2.0)), true);
      expect(sizeSet.contains(SizedFile.kb(3.0)), false);
    });

    test('objects work correctly in Map keys', () {
      final size1 = SizedFile.b(1024);
      final size2 = SizedFile.kb(1.0); // Same as size1

      final sizeMap = <SizedFile, String>{
        size1: 'first',
        size2: 'second', // Should overwrite 'first'
        SizedFile.kb(2.0): 'third',
      };

      expect(sizeMap.length, 2);
      expect(sizeMap[SizedFile.b(1024)], 'second');
      expect(sizeMap[SizedFile.kb(2.0)], 'third');
    });
  });

  group('SizedFile comparison operations', () {
    test('less than operator works correctly', () {
      final smaller = SizedFile.kb(1);
      final larger = SizedFile.mb(1);

      expect(smaller < larger, true);
      expect(larger < smaller, false);
    });

    test('less than or equal operator works correctly', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.b(1024); // Same as size1
      final size3 = SizedFile.mb(1);

      expect(size1 <= size2, true); // Equal
      expect(size1 <= size3, true); // Less than
      expect(size3 <= size1, false); // Greater than
    });

    test('greater than operator works correctly', () {
      final smaller = SizedFile.kb(1);
      final larger = SizedFile.mb(1);

      expect(larger > smaller, true);
      expect(smaller > larger, false);
    });

    test('greater than or equal operator works correctly', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.b(1024); // Same as size1
      final size3 = SizedFile.mb(1);

      expect(size1 >= size2, true); // Equal
      expect(size3 >= size1, true); // Greater than
      expect(size1 >= size3, false); // Less than
    });

    test('comparison with zero bytes', () {
      final zero = SizedFile.b(0);
      final nonZero = SizedFile.b(1);

      expect(zero < nonZero, true);
      expect(zero <= nonZero, true);
      expect(nonZero > zero, true);
      expect(nonZero >= zero, true);
      expect(zero >= zero, true);
      expect(zero <= zero, true);
    });

    test('comparison across different units', () {
      final bytes = SizedFile.b(500);
      final kilobytes = SizedFile.kb(1); // 1024 bytes
      final megabytes = SizedFile.mb(1); // 1048576 bytes
      final gigabytes = SizedFile.gb(1); // 1073741824 bytes

      expect(bytes < kilobytes, true);
      expect(kilobytes < megabytes, true);
      expect(megabytes < gigabytes, true);

      expect(gigabytes > megabytes, true);
      expect(megabytes > kilobytes, true);
      expect(kilobytes > bytes, true);
    });

    test('comparison transitivity', () {
      final small = SizedFile.kb(1);
      final medium = SizedFile.mb(1);
      final large = SizedFile.gb(1);

      // Transitivity: if a < b and b < c, then a < c
      expect(small < medium, true);
      expect(medium < large, true);
      expect(small < large, true);
    });

    test('sorting works correctly', () {
      final sizes = [
        SizedFile.gb(1),
        SizedFile.b(500),
        SizedFile.mb(100),
        SizedFile.kb(750),
      ];

      sizes.sort((a, b) => a.inBytes.compareTo(b.inBytes));

      expect(sizes[0].inBytes, 500); // 500 B
      expect(sizes[1].inBytes, 768000); // 750 KB
      expect(sizes[2].inBytes, 104857600); // 100 MB
      expect(sizes[3].inBytes, 1073741824); // 1 GB
    });

    test('comparison with identical values', () {
      final size1 = SizedFile.mb(5);
      final size2 = SizedFile.mb(5);

      expect(size1 <= size2, true);
      expect(size1 >= size2, true);
      expect(size1 < size2, false);
      expect(size1 > size2, false);
    });
  });

  group('SizedFile toString operation', () {
    test('toString returns formatted string', () {
      final size = SizedFile.mb(1.5);
      expect(size.toString(), '1.50 MB');
    });

    test('toString works with different sizes', () {
      expect(SizedFile.b(500).toString(), '500 B');
      expect(SizedFile.kb(2.5).toString(), '2.50 KB');
      expect(SizedFile.gb(1.25).toString(), '1.25 GB');
    });

    test('toString works with zero', () {
      expect(SizedFile.b(0).toString(), '0 B');
    });
  });

  group('SizedFile arithmetic operations', () {
    test('addition operator works correctly', () {
      final size1 = SizedFile.mb(1); // 1048576 bytes
      final size2 = SizedFile.kb(500); // 512000 bytes
      final result = size1 + size2; // 1560576 bytes

      expect(result.inBytes, 1560576);
      expect(
          result.inMB, closeTo(1.48828125, 0.001)); // More tolerant precision
    });

    test('addition with zero', () {
      final size = SizedFile.mb(5);
      final zero = SizedFile.b(0);
      final result = size + zero;

      expect(result.inBytes, size.inBytes);
      expect(result == size, true);
    });

    test('addition across different units', () {
      final bytes = SizedFile.b(500);
      final kb = SizedFile.kb(1); // 1024 bytes
      final mb = SizedFile.mb(1); // 1048576 bytes
      final total = bytes + kb + mb; // 1050100 bytes

      expect(total.inBytes, 1050100);
      expect(total.inMB, closeTo(1.00143432617, 0.0001));
    });

    test('addition is commutative', () {
      final size1 = SizedFile.kb(750);
      final size2 = SizedFile.mb(2);

      final result1 = size1 + size2;
      final result2 = size2 + size1;

      expect(result1 == result2, true);
      expect(result1.inBytes, result2.inBytes);
    });

    test('subtraction operator works correctly', () {
      final size1 = SizedFile.mb(2); // 2097152 bytes
      final size2 = SizedFile.kb(500); // 512000 bytes
      final result = size1 - size2; // 1585152 bytes

      expect(result.inBytes, 1585152);
      expect(result.inMB, closeTo(1.51171875, 0.001));
    });

    test('subtraction with zero', () {
      final size = SizedFile.mb(5);
      final zero = SizedFile.b(0);
      final result = size - zero;

      expect(result.inBytes, size.inBytes);
      expect(result == size, true);
    });

    test('subtraction resulting in zero', () {
      final size = SizedFile.kb(1);
      final result = size - size;

      expect(result.inBytes, 0);
      expect(result == SizedFile.b(0), true);
    });

    test('subtraction with larger second operand returns zero', () {
      final smaller = SizedFile.kb(500);
      final larger = SizedFile.mb(1);
      final result = smaller - larger;

      expect(result.inBytes, 0);
      expect(result == SizedFile.b(0), true);
    });

    test('subtraction across different units', () {
      final gb = SizedFile.gb(1); // 1073741824 bytes
      final mb = SizedFile.mb(100); // 104857600 bytes
      final kb = SizedFile.kb(500); // 512000 bytes
      final result = gb - mb - kb; // 968372224 bytes

      expect(result.inBytes, 968372224);
      expect(result.inMB, closeTo(923.51171875, 0.001));
    });

    test('arithmetic operations preserve precision', () {
      final size1 = SizedFile.b(1023);
      final size2 = SizedFile.b(1);
      final sum = size1 + size2;

      expect(sum.inBytes, 1024);
      expect(sum.inKB, 1.0);
    });

    test('complex arithmetic combinations', () {
      final documents = SizedFile.mb(5);
      final photos = SizedFile.mb(50);
      final videos = SizedFile.gb(2);

      final totalMedia = photos + videos;
      final everything = documents + totalMedia;
      final withoutVideos = everything - videos;

      expect(totalMedia.inBytes, photos.inBytes + videos.inBytes);
      expect(everything.inBytes,
          documents.inBytes + photos.inBytes + videos.inBytes);
      expect(withoutVideos.inBytes, documents.inBytes + photos.inBytes);
    });

    test('arithmetic with identical objects', () {
      final size = SizedFile.mb(1);
      final doubled = size + size;
      final zeroed = size - size;

      expect(doubled.inBytes, size.inBytes * 2);
      expect(zeroed.inBytes, 0);
    });

    test('chaining arithmetic operations', () {
      final base = SizedFile.kb(100);
      final step = SizedFile.kb(50);

      final result = base + step + step + step - step;
      final expected = SizedFile.kb(200); // 100 + 50 + 50 + 50 - 50

      expect(result == expected, true);
      expect(result.inBytes, expected.inBytes);
    });
  });

  group('SizedFile multiplication operator', () {
    test('multiplies by integer correctly', () {
      final size = SizedFile.mb(10);
      final result = size * 3;

      expect(result.inBytes, size.inBytes * 3);
      expect(result.inMB, 30.0);
    });

    test('multiplies by decimal correctly', () {
      final size = SizedFile.mb(10);
      final result = size * 0.5;

      expect(result.inBytes, (size.inBytes * 0.5).round());
      expect(result.inMB, closeTo(5.0, 0.01));
    });

    test('multiplies by zero returns zero', () {
      final size = SizedFile.mb(10);
      final result = size * 0;

      expect(result.inBytes, 0);
      expect(result == SizedFile.b(0), true);
    });

    test('multiplies by one returns same size', () {
      final size = SizedFile.mb(10);
      final result = size * 1;

      expect(result.inBytes, size.inBytes);
      expect(result == size, true);
    });

    test('multiplication preserves precision with rounding', () {
      final size = SizedFile.b(1000);
      final result = size * 1.5;

      expect(result.inBytes, 1500);
    });

    test('multiplication with large factors', () {
      final size = SizedFile.kb(1);
      final result = size * 1000;

      expect(result.inBytes, 1024000);
      expect(result.inKB, 1000.0);
    });

    test('multiplication chaining', () {
      final size = SizedFile.mb(1);
      final result = size * 2 * 3;

      expect(result.inMB, 6.0);
    });
  });

  group('SizedFile division operator', () {
    test('divides by integer correctly', () {
      final size = SizedFile.mb(30);
      final result = size / 3;

      expect(result.inMB, 10.0);
    });

    test('divides by decimal correctly', () {
      final size = SizedFile.mb(10);
      final result = size / 0.5;

      expect(result.inMB, 20.0);
    });

    test('divides by one returns same size', () {
      final size = SizedFile.mb(10);
      final result = size / 1;

      expect(result.inBytes, size.inBytes);
    });

    test('throws ArgumentError when dividing by zero', () {
      final size = SizedFile.mb(10);
      expect(() => size / 0, throwsArgumentError);
    });

    test('division chaining with numbers', () {
      final size = SizedFile.mb(100);
      final result = size / 2 / 5;

      expect(result.inMB, 10.0);
    });

    test('division preserves precision with rounding', () {
      final size = SizedFile.b(1000);
      final result = size / 3;

      expect(result.inBytes, 333); // Rounded
    });
  });

  group('SizedFile ratioTo method', () {
    test('calculates ratio between two sizes', () {
      final total = SizedFile.gb(1);
      final used = SizedFile.mb(250);
      final ratio = used.ratioTo(total);

      expect(ratio, closeTo(0.244140625, 0.001));
    });

    test('ratio of equal sizes returns 1', () {
      final size1 = SizedFile.mb(10);
      final size2 = SizedFile.mb(10);
      final ratio = size1.ratioTo(size2);

      expect(ratio, 1.0);
    });

    test('ratio of smaller to larger returns fraction', () {
      final small = SizedFile.mb(5);
      final large = SizedFile.mb(10);
      final ratio = small.ratioTo(large);

      expect(ratio, 0.5);
    });

    test('ratio of larger to smaller returns value greater than 1', () {
      final small = SizedFile.mb(5);
      final large = SizedFile.mb(10);
      final ratio = large.ratioTo(small);

      expect(ratio, 2.0);
    });

    test('throws ArgumentError when dividing by zero bytes', () {
      final size = SizedFile.mb(10);
      final zero = SizedFile.b(0);
      expect(() => size.ratioTo(zero), throwsArgumentError);
    });

    test('ratio calculation works with different units', () {
      final compressed = SizedFile.mb(25);
      final original = SizedFile.mb(100);
      final ratio = compressed.ratioTo(original);

      expect(ratio, 0.25);
      expect((ratio * 100), 25.0); // 25% compression
    });
  });

  group('SizedFile compareTo method', () {
    test('compareTo returns negative when smaller', () {
      final small = SizedFile.kb(1);
      final large = SizedFile.mb(1);

      expect(small.compareTo(large), isNegative);
    });

    test('compareTo returns zero when equal', () {
      final size1 = SizedFile.kb(1);
      final size2 = SizedFile.b(1024);

      expect(size1.compareTo(size2), 0);
    });

    test('compareTo returns positive when larger', () {
      final small = SizedFile.kb(1);
      final large = SizedFile.mb(1);

      expect(large.compareTo(small), isPositive);
    });

    test('list.sort() works with compareTo', () {
      final sizes = [
        SizedFile.gb(1),
        SizedFile.kb(100),
        SizedFile.mb(50),
        SizedFile.b(500),
      ];

      sizes.sort();

      expect(sizes[0].inBytes, 500);
      expect(sizes[1].inBytes, 102400);
      expect(sizes[2].inBytes, 52428800);
      expect(sizes[3].inBytes, 1073741824);
    });

    test('compareTo is consistent with comparison operators', () {
      final size1 = SizedFile.mb(5);
      final size2 = SizedFile.mb(10);

      expect(size1.compareTo(size2) < 0, size1 < size2);
      expect(size1.compareTo(size2) == 0, size1 == size2);
      expect(size2.compareTo(size1) > 0, size2 > size1);
    });

    test('compareTo is transitive', () {
      final small = SizedFile.kb(1);
      final medium = SizedFile.mb(1);
      final large = SizedFile.gb(1);

      expect(small.compareTo(medium) < 0, true);
      expect(medium.compareTo(large) < 0, true);
      expect(small.compareTo(large) < 0, true);
    });
  });

  group('SizedFile static helper methods', () {
    test('min returns smaller value', () {
      final size1 = SizedFile.mb(10);
      final size2 = SizedFile.mb(5);
      final result = SizedFile.min(size1, size2);

      expect(result == size2, true);
      expect(result.inMB, 5.0);
    });

    test('min with equal values returns first', () {
      final size1 = SizedFile.mb(10);
      final size2 = SizedFile.b(10485760); // 10 MB
      final result = SizedFile.min(size1, size2);

      expect(result == size1, true);
    });

    test('max returns larger value', () {
      final size1 = SizedFile.mb(10);
      final size2 = SizedFile.mb(5);
      final result = SizedFile.max(size1, size2);

      expect(result == size1, true);
      expect(result.inMB, 10.0);
    });

    test('max with equal values returns first', () {
      final size1 = SizedFile.mb(10);
      final size2 = SizedFile.b(10485760); // 10 MB
      final result = SizedFile.max(size1, size2);

      expect(result == size1, true);
    });

    test('sum returns total of all sizes', () {
      final sizes = [
        SizedFile.mb(10),
        SizedFile.mb(20),
        SizedFile.mb(30),
      ];
      final result = SizedFile.sum(sizes);

      expect(result.inMB, 60.0);
    });

    test('sum with empty list returns zero', () {
      final result = SizedFile.sum([]);

      expect(result.inBytes, 0);
    });

    test('sum with single element returns that element', () {
      final size = SizedFile.mb(10);
      final result = SizedFile.sum([size]);

      expect(result == size, true);
    });

    test('sum with mixed units', () {
      final sizes = [
        SizedFile.kb(500),
        SizedFile.mb(1),
        SizedFile.gb(1),
      ];
      final result = SizedFile.sum(sizes);

      // 500 KB = 512000 bytes
      // 1 MB = 1048576 bytes
      // 1 GB = 1073741824 bytes
      // Total = 1075302400 bytes
      expect(result.inBytes, 1075302400);
    });

    test('average returns mean of all sizes', () {
      final sizes = [
        SizedFile.mb(10),
        SizedFile.mb(20),
        SizedFile.mb(30),
      ];
      final result = SizedFile.average(sizes);

      expect(result.inMB, 20.0);
    });

    test('average with empty list returns zero', () {
      final result = SizedFile.average([]);

      expect(result.inBytes, 0);
    });

    test('average with single element returns that element', () {
      final size = SizedFile.mb(10);
      final result = SizedFile.average([size]);

      expect(result == size, true);
    });

    test('average rounds to nearest byte', () {
      final sizes = [
        SizedFile.b(1),
        SizedFile.b(2),
        SizedFile.b(3),
      ];
      final result = SizedFile.average(sizes);

      expect(result.inBytes, 2); // (1+2+3)/3 = 2
    });

    test('average with mixed units', () {
      final sizes = [
        SizedFile.kb(100),
        SizedFile.mb(1),
        SizedFile.kb(100),
      ];
      final result = SizedFile.average(sizes);

      expect(result.inKB, closeTo(408.0, 1.0));
    });
  });
}
