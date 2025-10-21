import 'package:sized_file/sized_file.dart';

void main() {
  print('=== Sized File Package Examples ===\n');

  // Example 1: Creating SizedFile instances from different units
  print('1. Creating SizedFile instances:');
  final fromBytes = SizedFile.b(1024);
  final fromKB = SizedFile.kb(1.5);
  final fromMB = SizedFile.mb(100);
  final fromGB = SizedFile.gb(2.5);
  final fromTB = SizedFile.tb(1);

  print('From bytes: ${fromBytes.format()}');
  print('From KB: ${fromKB.format()}');
  print('From MB: ${fromMB.format()}');
  print('From GB: ${fromGB.format()}');
  print('From TB: ${fromTB.format()}');
  print('');

  // Example 2: Accessing different units
  print('2. Accessing different units:');
  final fileSize = SizedFile.mb(5);
  print('5 MB in different units:');
  print('  Bytes: ${fileSize.inBytes}');
  print('  KB: ${fileSize.inKB}');
  print('  MB: ${fileSize.inMB}');
  print('  GB: ${fileSize.inGB}');
  print('');

  // Example 3: Formatting with different fraction digits
  print('3. Custom fraction digits:');
  final size = SizedFile.kb(1.5);
  print('1.5 KB formatted:');
  print('  0 digits: ${size.format(fractionDigits: 0)}');
  print('  1 digit:  ${size.format(fractionDigits: 1)}');
  print('  2 digits: ${size.format(fractionDigits: 2)}');
  print('  3 digits: ${size.format(fractionDigits: 3)}');
  print('');

  // Example 4: Custom postfixes for a single format call
  print('4. Custom postfixes:');
  final customSize = SizedFile.mb(5);
  final customPostfixes = {
    'B': 'bytes',
    'KB': 'kilobytes',
    'MB': 'megabytes',
    'GB': 'gigabytes',
    'TB': 'terabytes',
  };
  print('Default: ${customSize.format()}');
  print('Custom:  ${customSize.format(postfixes: customPostfixes)}');
  print('');

  // Example 5: Global postfix generator (for localization)
  print('5. Global postfix generator:');
  SizedFile.setPostfixesGenerator(() {
    return {'B': 'B', 'KB': 'Ko', 'MB': 'Mo', 'GB': 'Go', 'TB': 'To'};
  });
  print('French style: ${SizedFile.mb(5).format()}');

  // Reset to default
  SizedFile.setPostfixesGenerator(() {
    return {'B': 'B', 'KB': 'KB', 'MB': 'MB', 'GB': 'GB', 'TB': 'TB'};
  });
  print('');

  // Example 6: Equality and comparison operations
  print('6. Equality and comparison operations:');
  demonstrateEqualityAndComparison();
  print('');

  // Example 7: File collection management
  print('7. File collection management:');
  demonstrateFileCollections();
  print('');

  // Example 8: File upload progress simulation
  print('8. File upload progress:');
  simulateFileUpload(5242880); // 5 MB
  print('');

  // Example 9: Storage summary
  print('9. Storage summary:');
  printStorageSummary(107374182400, 268435456000);
  print('');

  // Example 10: File size validation with comparison
  print('10. File size validation with comparison:');
  validateSizedFileWithComparison(2097152, 5.0); // 2 MB file, 5 MB limit
  validateSizedFileWithComparison(10485760, 5.0); // 10 MB file, 5 MB limit
  print('');

  // Example 11: Bandwidth calculation
  print('11. Bandwidth calculation:');
  estimateDownloadTime(52428800, 10.5); // 50 MB file at 10.5 MB/s
  print('');

  // Example 12: Different size thresholds
  print('10. Automatic unit selection:');
  final sizes = [
    SizedFile.b(500), // Bytes
    SizedFile.b(2048), // Kilobytes
    SizedFile.mb(1.5), // Megabytes
    SizedFile.gb(2.5), // Gigabytes
  ];
  for (var s in sizes) {
    print('  ${s.inBytes.toString().padLeft(12)} bytes = ${s.format()}');
  }
}

/// Simulates a file upload progress display
void simulateFileUpload(int totalBytes) {
  final total = SizedFile.b(totalBytes);
  final milestones = [0.25, 0.5, 0.75, 1.0];

  print('Uploading file (${total.format()})...');
  for (var progress in milestones) {
    final uploadedBytes = (totalBytes * progress).toInt();
    final uploaded = SizedFile.b(uploadedBytes);
    final percent = (progress * 100).toStringAsFixed(0);
    print('  Progress: $percent% - ${uploaded.format()} / ${total.format()}');
  }
}

/// Displays storage usage summary
void printStorageSummary(int usedBytes, int totalBytes) {
  final used = SizedFile.b(usedBytes);
  final total = SizedFile.b(totalBytes);
  final free = SizedFile.b(totalBytes - usedBytes);

  final percentUsed = (usedBytes / totalBytes * 100).toStringAsFixed(1);

  print('Storage Usage:');
  print('  Used:      ${used.format()} ($percentUsed%)');
  print('  Total:     ${total.format()}');
  print('  Available: ${free.format()}');
}

/// Validates if a file size is within the allowed limit using comparison operators
void validateSizedFileWithComparison(int fileSizeBytes, double maxMB) {
  final fileSize = SizedFile.b(fileSizeBytes);
  final maxSize = SizedFile.mb(maxMB);

  // Use comparison operators instead of manual calculations
  final isValid = fileSize <= maxSize;
  print(
    'File: ${fileSize.format()} - Limit: ${maxSize.format()} - ${isValid ? "✓ Valid" : "✗ Too large"}',
  );
}

/// Estimates download time based on file size and speed
void estimateDownloadTime(int fileSizeBytes, double speedMBps) {
  final fileSize = SizedFile.b(fileSizeBytes);
  final seconds = fileSize.inMB / speedMBps;

  print('Download estimate:');
  print('  File size: ${fileSize.format()}');
  print('  Speed:     ${speedMBps.toStringAsFixed(2)} MB/s');
  print('  Time:      ${seconds.toStringAsFixed(1)} seconds');
}

/// Demonstrates equality and comparison operations
void demonstrateEqualityAndComparison() {
  print('Equality operations:');
  final size1 = SizedFile.kb(1);
  final size2 = SizedFile.b(1024);
  final size3 = SizedFile.mb(0.0009765625);

  print('  ${size1.format()} == ${size2.format()}: ${size1 == size2}');
  print('  ${size2.format()} == ${size3.format()}: ${size2 == size3}');
  print('  All represent the same size: ${size1 == size2 && size2 == size3}');

  print('');
  print('Comparison operations:');
  final small = SizedFile.kb(500);
  final medium = SizedFile.mb(1);
  final large = SizedFile.gb(1);

  print('  ${small.format()} < ${medium.format()}: ${small < medium}');
  print('  ${medium.format()} < ${large.format()}: ${medium < large}');
  print('  ${large.format()} > ${small.format()}: ${large > small}');
  print('  ${small.format()} <= ${SizedFile.kb(500).format()}: ${small <= SizedFile.kb(500)}');
  print('  ${large.format()} >= ${medium.format()}: ${large >= medium}');

  print('');
  print('Finding min/max sizes:');
  final sizes = [large, small, medium];
  final maxSize = sizes.reduce((a, b) => a > b ? a : b);
  final minSize = sizes.reduce((a, b) => a < b ? a : b);
  print('  Largest: ${maxSize.format()}');
  print('  Smallest: ${minSize.format()}');
}

/// Demonstrates file collection management with equality and comparison
void demonstrateFileCollections() {
  print('Working with collections:');

  // Using Set to store unique file sizes
  final fileSizes = <SizedFile>{
    SizedFile.kb(1),
    SizedFile.b(1024), // Same as 1 KB, won't be added twice
    SizedFile.mb(1),
    SizedFile.gb(1),
    SizedFile.kb(1), // Duplicate, won't be added
  };

  print('  Unique file sizes in Set: ${fileSizes.length}');
  for (var size in fileSizes) {
    print('    ${size.format()}');
  }

  print('');
  print('Using Map with SizedFile keys:');
  final fileMap = <SizedFile, String>{
    SizedFile.kb(1): 'Small document',
    SizedFile.mb(5): 'Photo',
    SizedFile.mb(50): 'Video clip',
    SizedFile.gb(1): 'HD Movie',
  };

  fileMap.forEach((size, description) {
    print('    ${size.format().padLeft(10)}: $description');
  });

  print('');
  print('Sorting files by size:');
  final randomSizes = [
    SizedFile.gb(2),
    SizedFile.kb(750),
    SizedFile.mb(100),
    SizedFile.b(500),
    SizedFile.tb(1),
  ];

  print('  Before sorting:');
  for (var size in randomSizes) {
    print('    ${size.format()}');
  }

  randomSizes.sort((a, b) => a.inBytes.compareTo(b.inBytes));

  print('  After sorting (smallest to largest):');
  for (var size in randomSizes) {
    print('    ${size.format()}');
  }

  print('');
  print('Filtering files by size:');
  final allFiles = [
    SizedFile.kb(50), // Small
    SizedFile.mb(2), // Medium
    SizedFile.mb(15), // Large
    SizedFile.kb(100), // Small
    SizedFile.gb(1), // Very large
  ];

  final threshold = SizedFile.mb(10);
  final largeFiles = allFiles.where((file) => file > threshold).toList();
  final smallFiles = allFiles.where((file) => file <= threshold).toList();

  print('  All files: ${allFiles.map((f) => f.format()).join(', ')}');
  print('  Large files (> ${threshold.format()}): ${largeFiles.map((f) => f.format()).join(', ')}');
  print('  Small files (<= ${threshold.format()}): ${smallFiles.map((f) => f.format()).join(', ')}');

  print('');
  print('Storage capacity check:');
  final totalStorage = allFiles.fold<SizedFile>(
    SizedFile.b(0),
    (sum, file) => SizedFile.b(sum.inBytes + file.inBytes),
  );
  final availableSpace = SizedFile.gb(2);

  print('  Total files size: ${totalStorage.format()}');
  print('  Available space: ${availableSpace.format()}');
  print('  Fits in storage: ${totalStorage <= availableSpace ? "✓ Yes" : "✗ No"}');
}
