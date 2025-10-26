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

  // Example 2: Creating from mixed units
  print('2. Creating from mixed units with SizedFile.units:');
  mixedUnitsExample();
  print('');

  // Example 3: Accessing different units
  print('3. Accessing different units:');
  final fileSize = SizedFile.mb(5);
  print('5 MB in different units:');
  print('  Bytes: ${fileSize.inBytes}');
  print('  KB: ${fileSize.inKB}');
  print('  MB: ${fileSize.inMB}');
  print('  GB: ${fileSize.inGB}');
  print('  TB: ${fileSize.inTB}');
  print('');

  // Example 4: Formatting with different fraction digits
  print('4. Custom fraction digits:');
  final size = SizedFile.kb(1.5);
  print('1.5 KB formatted:');
  print('  0 digits: ${size.format(fractionDigits: 0)}');
  print('  1 digit:  ${size.format(fractionDigits: 1)}');
  print('  2 digits: ${size.format(fractionDigits: 2)}');
  print('  3 digits: ${size.format(fractionDigits: 3)}');
  print('');

  // Example 5: Custom postfixes for a single format call
  print('5. Custom postfixes:');
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

  // Example 6: Global postfix generator (for localization)
  print('6. Global postfix generator:');
  SizedFile.setPostfixesGenerator(() {
    return {'B': 'B', 'KB': 'Ko', 'MB': 'Mo', 'GB': 'Go', 'TB': 'To'};
  });
  print('French style: ${SizedFile.mb(5).format()}');

  // Reset to default
  SizedFile.setPostfixesGenerator(() {
    return {'B': 'B', 'KB': 'KB', 'MB': 'MB', 'GB': 'GB', 'TB': 'TB'};
  });
  print('');

  // Example 7: Arithmetic operations
  print('7. Arithmetic operations:');
  demonstrateArithmeticOperations();
  print('');

  // Example 8: Equality and comparison operations
  print('8. Equality and comparison operations:');
  demonstrateEqualityAndComparison();
  print('');

  // Example 9: File collection management
  print('9. File collection management:');
  demonstrateFileCollections();
  print('');

  // Example 10: File upload progress simulation
  print('10. File upload progress:');
  simulateFileUpload(5242880); // 5 MB
  print('');

  // Example 11: Storage summary
  print('11. Storage summary:');
  printStorageSummary(107374182400, 268435456000);
  print('');

  // Example 12: File size validation with comparison
  print('12. File size validation with comparison:');
  validateSizedFileWithComparison(2097152, 5.0); // 2 MB file, 5 MB limit
  validateSizedFileWithComparison(10485760, 5.0); // 10 MB file, 5 MB limit
  print('');

  // Example 13: Bandwidth calculation
  print('13. Bandwidth calculation:');
  estimateDownloadTime(52428800, 10.5); // 50 MB file at 10.5 MB/s
  print('');

  // Example 14: Different size thresholds
  print('14. Automatic unit selection:');
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

/// Demonstrates creating SizedFile from mixed units
void mixedUnitsExample() {
  // Example 1: Video file with mixed units
  print('Video file size (2 GB + 500 MB + 256 KB):');
  final videoFile = SizedFile.units(gb: 2, mb: 500, kb: 256);
  print('  Total: ${videoFile.format()}');
  print('  In MB: ${videoFile.inMB}');
  print('  In Bytes: ${videoFile.inBytes}');
  print('');

  // Example 2: Precise file size with bytes and larger units
  print('Database backup (10 MB + 1024 bytes):');
  final dbBackup = SizedFile.units(mb: 10, bytes: 1024);
  print('  Total: ${dbBackup.format()}');
  print('  In Bytes: ${dbBackup.inBytes}');
  print('');

  // Example 3: Complex media project
  print('Media project (1 GB + 750 MB + 512 KB + 256 bytes):');
  final mediaProject = SizedFile.units(gb: 1, mb: 750, kb: 512, bytes: 256);
  print('  Total: ${mediaProject.format()}');
  print('  In GB: ${mediaProject.inGB.toStringAsFixed(2)}');
  print('');

  // Example 4: Using only one unit (same as direct constructor)
  print('Using units() with single unit:');
  final singleUnit = SizedFile.units(mb: 500);
  final directConstructor = SizedFile.mb(500);
  print('  units(mb: 500): ${singleUnit.format()}');
  print('  mb(500): ${directConstructor.format()}');
  print('  Are equal: ${singleUnit == directConstructor}');
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

/// Demonstrates arithmetic operations with SizedFile objects
void demonstrateArithmeticOperations() {
  print('Addition operations:');
  final doc1 = SizedFile.mb(2);
  final doc2 = SizedFile.kb(500);
  final doc3 = SizedFile.b(1024);

  print('  Document 1: ${doc1.format()}');
  print('  Document 2: ${doc2.format()}');
  print('  Document 3: ${doc3.format()}');

  final totalDocs = doc1 + doc2 + doc3;
  print('  Total size: ${totalDocs.format()}');
  print('');

  print('Subtraction operations:');
  final totalStorage = SizedFile.gb(1);
  final usedSpace = SizedFile.mb(750);
  final availableSpace = totalStorage - usedSpace;

  print('  Total storage: ${totalStorage.format()}');
  print('  Used space:    ${usedSpace.format()}');
  print('  Available:     ${availableSpace.format()}');
  print('');

  print('Combining operations:');
  final photos = SizedFile.mb(200);
  final videos = SizedFile.gb(1.5);
  final backup = SizedFile.mb(50);

  final mediaTotal = photos + videos;
  final withBackup = mediaTotal + backup;
  final withoutBackup = withBackup - backup;

  print('  Photos: ${photos.format()}');
  print('  Videos: ${videos.format()}');
  print('  Backup: ${backup.format()}');
  print('  Media total: ${mediaTotal.format()}');
  print('  With backup: ${withBackup.format()}');
  print('  Without backup: ${withoutBackup.format()}');
  print('  Backup removed correctly: ${withoutBackup == mediaTotal}');
  print('');

  print('Practical storage calculation:');
  final files = [
    SizedFile.mb(5), // Document
    SizedFile.mb(25), // Presentation
    SizedFile.mb(150), // Video
    SizedFile.kb(750), // Spreadsheet
    SizedFile.gb(1), // Database backup
  ];

  var runningTotal = SizedFile.b(0);
  print('  Building total from individual files:');
  for (int i = 0; i < files.length; i++) {
    runningTotal = runningTotal + files[i];
    print('    Adding ${files[i].format()}: Running total = ${runningTotal.format()}');
  }

  final deviceCapacity = SizedFile.gb(2);
  final remainingSpace = deviceCapacity - runningTotal;
  print('  Device capacity: ${deviceCapacity.format()}');
  print('  Remaining space: ${remainingSpace.format()}');
  print('  Can fit more files: ${remainingSpace > SizedFile.mb(100) ? "✓ Yes" : "✗ No"}');
  print('');

  // Example 8: Multiplication and Division operations
  print('8. Multiplication and Division Operations:');
  multiplicationDivisionExample();
  print('');

  // Example 9: Static helper methods
  print('9. Static Helper Methods:');
  staticHelpersExample();
  print('');

  // Example 10: Comparable interface and sorting
  print('10. Comparable Interface and Sorting:');
  comparableExample();
  print('');

  // Example 11: Practical real-world scenarios
  print('11. Real-World Scenarios:');
  realWorldScenarios();
}

/// Demonstrates multiplication, division, and ratio calculation operations
void multiplicationDivisionExample() {
  print('Multiplication by scalar:');
  final baseSize = SizedFile.mb(10);

  print('  Base size: ${baseSize.format()}');
  print('  × 2: ${(baseSize * 2).format()}');
  print('  × 3: ${(baseSize * 3).format()}');
  print('  × 0.5: ${(baseSize * 0.5).format()}');
  print('  × 1.5: ${(baseSize * 1.5).format()}');
  print('');

  print('Division by scalar:');
  final largeFile = SizedFile.gb(1);

  print('  Base size: ${largeFile.format()}');
  print('  ÷ 2: ${(largeFile / 2).format()}');
  print('  ÷ 4: ${(largeFile / 4).format()}');
  print('  ÷ 10: ${(largeFile / 10).format()}');
  print('');

  print('Ratio calculation with ratioTo():');
  final used = SizedFile.mb(250);
  final capacity = SizedFile.gb(1);
  final ratio = used.ratioTo(capacity);

  print('  Used: ${used.format()}');
  print('  Capacity: ${capacity.format()}');
  print('  Usage ratio: ${(ratio * 100).toStringAsFixed(1)}%');
  print('');

  print('Calculating per-item size:');
  final totalSize = SizedFile.gb(5);
  const fileCount = 500;
  final avgFileSize = totalSize / fileCount;

  print('  Total: ${totalSize.format()}');
  print('  File count: $fileCount');
  print('  Average per file: ${avgFileSize.format()}');
  print('');

  print('Quota calculation:');
  final userQuota = SizedFile.gb(10);
  final quotaPercentage = 0.25; // 25% of quota
  final allocatedSpace = userQuota * quotaPercentage;

  print('  Total quota: ${userQuota.format()}');
  print('  Allocated (25%): ${allocatedSpace.format()}');
}

/// Demonstrates static helper methods
void staticHelpersExample() {
  final sizes = [
    SizedFile.mb(150),
    SizedFile.kb(500),
    SizedFile.gb(2),
    SizedFile.mb(75),
    SizedFile.kb(250),
  ];

  print('File sizes: ${sizes.map((s) => s.format()).join(", ")}');
  print('');

  print('Using min() and max():');
  final smallest = SizedFile.min(sizes);
  final largest = SizedFile.max(sizes);

  print('  Smallest file: ${smallest.format()}');
  print('  Largest file: ${largest.format()}');
  print('');

  print('Using sum():');
  final total = SizedFile.sum(sizes);
  print('  Total size: ${total.format()}');
  print('  Total bytes: ${total.inBytes}');
  print('');

  print('Using average():');
  final avg = SizedFile.average(sizes);
  print('  Average size: ${avg.format()}');
  print('  Count: ${sizes.length}');
  print('');

  print('Filtering and aggregating:');
  final largeSizes = sizes.where((s) => s > SizedFile.mb(100)).toList();
  final smallSizes = sizes.where((s) => s <= SizedFile.mb(100)).toList();

  print('  Large files (> 100 MB): ${largeSizes.map((s) => s.format()).join(", ")}');
  print('  Large files total: ${SizedFile.sum(largeSizes).format()}');
  print('  Small files (≤ 100 MB): ${smallSizes.map((s) => s.format()).join(", ")}');
  print('  Small files total: ${SizedFile.sum(smallSizes).format()}');
}

/// Demonstrates Comparable interface and sorting
void comparableExample() {
  final unsorted = [
    SizedFile.gb(5),
    SizedFile.kb(100),
    SizedFile.mb(500),
    SizedFile.b(2048),
    SizedFile.gb(1),
    SizedFile.mb(50),
  ];

  print('Unsorted files:');
  for (final size in unsorted) {
    print('  ${size.format()}');
  }
  print('');

  print('Sorted (ascending) using .sort():');
  final ascending = List<SizedFile>.from(unsorted);
  ascending.sort(); // Uses compareTo automatically
  for (final size in ascending) {
    print('  ${size.format()}');
  }
  print('');

  print('Sorted (descending):');
  final descending = List<SizedFile>.from(unsorted);
  descending.sort((a, b) => b.compareTo(a));
  for (final size in descending) {
    print('  ${size.format()}');
  }
  print('');

  print('Using compareTo directly:');
  final size1 = SizedFile.mb(100);
  final size2 = SizedFile.mb(200);
  final comparison = size1.compareTo(size2);

  print('  ${size1.format()} vs ${size2.format()}');
  print('  compareTo result: $comparison');
  print('  Interpretation: ${comparison < 0 ? "first is smaller" : comparison > 0 ? "first is larger" : "equal"}');
}

/// Demonstrates real-world practical scenarios
void realWorldScenarios() {
  print('Scenario 1: Cloud backup pricing');
  const pricePerGB = 0.023; // $0.023 per GB
  final dataToBackup = SizedFile.sum([
    SizedFile.gb(50), // Documents
    SizedFile.gb(200), // Photos
    SizedFile.gb(100), // Videos
  ]);

  final totalGB = dataToBackup.inGB;
  final monthlyCost = totalGB * pricePerGB;

  print('  Data to backup: ${dataToBackup.format()}');
  print('  Price per GB: \$${pricePerGB}');
  print('  Monthly cost: \$${monthlyCost.toStringAsFixed(2)}');
  print('');

  print('Scenario 2: Download time estimation');
  final fileToDownload = SizedFile.gb(4.7); // DVD image
  const downloadSpeed = 10.5; // MB/s

  final timeInSeconds = fileToDownload.inMB / downloadSpeed;
  final minutes = (timeInSeconds / 60).floor();
  final seconds = (timeInSeconds % 60).round();

  print('  File size: ${fileToDownload.format()}');
  print('  Speed: $downloadSpeed MB/s');
  print('  Estimated time: ${minutes}m ${seconds}s');
  print('');

  print('Scenario 3: Compression ratio');
  final originalSize = SizedFile.mb(150);
  final compressedSize = SizedFile.mb(45);
  final savedSpace = originalSize - compressedSize;
  final compressionRatio = compressedSize.ratioTo(originalSize);

  print('  Original: ${originalSize.format()}');
  print('  Compressed: ${compressedSize.format()}');
  print('  Saved: ${savedSpace.format()}');
  print('  Compression ratio: ${(compressionRatio * 100).toStringAsFixed(1)}%');
  print('  Space reduction: ${((1 - compressionRatio) * 100).toStringAsFixed(1)}%');
  print('');

  print('Scenario 4: Multi-tier storage allocation');
  final totalStorage = SizedFile.tb(1);
  final hotStorage = totalStorage * 0.2; // 20% hot (SSD)
  final warmStorage = totalStorage * 0.3; // 30% warm (HDD)
  final coldStorage = totalStorage * 0.5; // 50% cold (Archive)

  print('  Total capacity: ${totalStorage.format()}');
  print('  Hot (SSD, 20%): ${hotStorage.format()}');
  print('  Warm (HDD, 30%): ${warmStorage.format()}');
  print('  Cold (Archive, 50%): ${coldStorage.format()}');
  print('  Verification: ${(hotStorage + warmStorage + coldStorage == totalStorage ? "✓" : "✗")}');
}
