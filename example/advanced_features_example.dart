import 'package:file_sized/file_sized.dart';

/// This example demonstrates the advanced features of the FileSize package:
/// - Arithmetic operations (multiplication, division)
/// - Static helper methods (min, max, sum, average)
/// - Comparable interface
/// - Fluent API with conversion methods
/// - Real-world use cases
void main() {
  print('=== FileSize Advanced Features ===\n');

  // 1. Arithmetic Operations
  arithmeticOperations();

  // 2. Static Helper Methods
  staticHelperMethods();

  // 3. Comparable Interface
  comparableInterface();

  // 4. Real-World Examples
  realWorldExamples();
}

void arithmeticOperations() {
  print('1. ARITHMETIC OPERATIONS');
  print('=' * 60);

  // Multiplication
  print('\nMultiplication by Scalar:');
  final baseFile = FileSize.mb(100);
  print('  Base size: ${baseFile.format()}');
  print('  Double (×2): ${(baseFile * 2).format()}');
  print('  Triple (×3): ${(baseFile * 3).format()}');
  print('  Half (×0.5): ${(baseFile * 0.5).format()}');

  // Division by scalar
  print('\nDivision by Scalar:');
  final largeFile = FileSize.gb(1);
  print('  Base size: ${largeFile.format()}');
  print('  Half (÷2): ${(largeFile / 2).format()}');
  print('  Quarter (÷4): ${(largeFile / 4).format()}');
  print('  Tenth (÷10): ${(largeFile / 10).format()}');

  // Ratio calculation
  print('\nRatio Calculation with ratioTo():');
  final used = FileSize.mb(350);
  final total = FileSize.gb(1);
  final ratio = used.ratioTo(total);
  print('  Used: ${used.format()}');
  print('  Total: ${total.format()}');
  print('  Ratio: ${(ratio * 100).toStringAsFixed(2)}%');

  // Complex calculations
  print('\nComplex Calculations:');
  final doc1 = FileSize.mb(2.5);
  final doc2 = FileSize.mb(3.7);
  final doc3 = FileSize.mb(1.2);
  final backup = (doc1 + doc2 + doc3) * 2; // Double for backup

  print('  Document 1: ${doc1.format()}');
  print('  Document 2: ${doc2.format()}');
  print('  Document 3: ${doc3.format()}');
  print('  Total: ${(doc1 + doc2 + doc3).format()}');
  print('  Backup (2x): ${backup.format()}');

  print('');
}

void staticHelperMethods() {
  print('2. STATIC HELPER METHODS');
  print('=' * 60);

  final files = [
    FileSize.mb(25),
    FileSize.kb(750),
    FileSize.gb(1),
    FileSize.mb(150),
    FileSize.kb(500),
    FileSize.mb(75),
  ];

  print('\nFile Collection:');
  for (var i = 0; i < files.length; i++) {
    print('  File ${i + 1}: ${files[i].format()}');
  }

  // Min/Max
  print('\nFinding Min and Max:');
  final minFile = FileSize.min(files);
  final maxFile = FileSize.max(files);
  print('  Smallest: ${minFile.format()}');
  print('  Largest: ${maxFile.format()}');

  // Sum
  print('\nCalculating Total:');
  final totalSize = FileSize.sum(files);
  print('  Total size: ${totalSize.format()}');
  print('  Total in bytes: ${totalSize.inBytes}');

  // Average
  print('\nCalculating Average:');
  final avgSize = FileSize.average(files);
  print('  Average size: ${avgSize.format()}');
  print('  File count: ${files.length}');

  // Filtered aggregation
  print('\nFiltered Aggregation:');
  final largeFiles = files.where((f) => f > FileSize.mb(50)).toList();
  final smallFiles = files.where((f) => f <= FileSize.mb(50)).toList();

  print('  Large files (>50MB): ${largeFiles.length}');
  print('  Large files total: ${FileSize.sum(largeFiles).format()}');
  print('  Small files (≤50MB): ${smallFiles.length}');
  print('  Small files total: ${FileSize.sum(smallFiles).format()}');

  print('');
}

void comparableInterface() {
  print('3. COMPARABLE INTERFACE');
  print('=' * 60);

  final unsorted = [
    FileSize.gb(3),
    FileSize.kb(500),
    FileSize.mb(250),
    FileSize.b(1024),
    FileSize.gb(1),
    FileSize.mb(50),
    FileSize.kb(100),
  ];

  print('\nOriginal Order:');
  for (var i = 0; i < unsorted.length; i++) {
    print('  ${i + 1}. ${unsorted[i].format()}');
  }

  // Ascending sort
  print('\nSorted (Ascending):');
  final ascending = List<FileSize>.from(unsorted);
  ascending.sort(); // Uses compareTo
  for (var i = 0; i < ascending.length; i++) {
    print('  ${i + 1}. ${ascending[i].format()}');
  }

  // Descending sort
  print('\nSorted (Descending):');
  final descending = List<FileSize>.from(unsorted);
  descending.sort((a, b) => b.compareTo(a));
  for (var i = 0; i < descending.length; i++) {
    print('  ${i + 1}. ${descending[i].format()}');
  }

  // Direct comparison
  print('\nDirect Comparison:');
  final size1 = FileSize.mb(500);
  final size2 = FileSize.gb(1);
  final result = size1.compareTo(size2);

  print('  ${size1.format()} vs ${size2.format()}');
  print('  compareTo result: $result');
  print(
      '  Meaning: ${result < 0 ? "${size1.format()} is smaller" : result > 0 ? "${size1.format()} is larger" : "Equal"}');

  // Finding median
  print('\nFinding Median:');
  ascending.sort();
  final medianIndex = ascending.length ~/ 2;
  final median = ascending[medianIndex];
  print('  Median size: ${median.format()}');

  print('');
}

void realWorldExamples() {
  print('5. REAL-WORLD EXAMPLES');
  print('=' * 60);

  // Example 1: Disk quota management
  print('\nExample 1: Disk Quota Management');
  final userQuota = FileSize.gb(100);
  final currentUsage = FileSize.gb(87.5);
  final remaining = userQuota - currentUsage;
  final usagePercent = currentUsage.ratioTo(userQuota);

  print('\n  User Storage Quota:');
  print('  Quota: ${userQuota.format()}');
  print('  Used: ${currentUsage.format()} (${(usagePercent * 100).toStringAsFixed(1)}%)');
  print('  Remaining: ${remaining.format()}');
  print('  Status: ${usagePercent > 0.9 ? "⚠️ Critical" : usagePercent > 0.75 ? "⚠️ Warning" : "✓ OK"}');

  // Example 2: Backup rotation
  print('\nExample 2: Backup Rotation Strategy');
  final backups = [
    FileSize.gb(15.2), // Daily
    FileSize.gb(14.8), // Daily
    FileSize.gb(45.0), // Weekly
    FileSize.gb(120.0), // Monthly
  ];

  final totalBackup = FileSize.sum(backups);
  final avgBackup = FileSize.average(backups);
  final maxBackup = FileSize.max(backups);

  print('  Backups: ${backups.length}');
  print('  Total size: ${totalBackup.format()}');
  print('  Average size: ${avgBackup.format()}');
  print('  Largest: ${maxBackup.format()}');
  print('  Storage needed (3x): ${(totalBackup * 3).format()}');

  // Example 3: Video streaming quality
  print('\nExample 3: Video Streaming Quality Selection');
  final videoDuration = 120; // minutes
  final qualities = {
    '4K': FileSize.gb(videoDuration * 0.15), // ~150 MB/min
    '1080p': FileSize.gb(videoDuration * 0.06), // ~60 MB/min
    '720p': FileSize.gb(videoDuration * 0.03), // ~30 MB/min
    '480p': FileSize.mb(videoDuration * 15.0), // ~15 MB/min
  };

  print('  Video duration: $videoDuration minutes');
  qualities.forEach((quality, size) {
    print('  $quality: ${size.format()}');
  });

  // Example 4: Cost calculation
  print('\nExample 4: Cloud Storage Cost Calculation');
  const costPerGB = 0.023; // $0.023 per GB
  final storedData = FileSize.sum([
    FileSize.gb(125), // Documents
    FileSize.gb(450), // Photos
    FileSize.gb(280), // Videos
    FileSize.gb(95), // Backups
  ]);

  final monthlyCost = storedData.inGB * costPerGB;
  final yearlyCost = monthlyCost * 12;

  print('  Total data: ${storedData.format()}');
  print('  Rate: \$${costPerGB}/GB/month');
  print('  Monthly cost: \$${monthlyCost.toStringAsFixed(2)}');
  print('  Yearly cost: \$${yearlyCost.toStringAsFixed(2)}');

  // Example 5: Data transfer estimation
  print('\nExample 5: Data Transfer Time Estimation');
  final dataToTransfer = FileSize.gb(50);
  final speeds = {
    'USB 2.0 (480 Mbps)': 60.0, // MB/s
    'USB 3.0 (5 Gbps)': 500.0,
    'Gigabit Ethernet': 125.0,
    'WiFi 6 (typical)': 150.0,
  };

  print('  Data size: ${dataToTransfer.format()}');
  speeds.forEach((method, speedMBps) {
    final seconds = dataToTransfer.inMB / speedMBps;
    final minutes = seconds / 60;
    print('  $method: ${minutes.toStringAsFixed(1)} min');
  });

  print('');
}
