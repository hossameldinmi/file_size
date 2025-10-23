import 'package:sized_file/sized_file.dart';

/// This example demonstrates the advanced features of the SizedFile package:
/// - Arithmetic operations (multiplication, division)
/// - Static helper methods (min, max, sum, average)
/// - Comparable interface
/// - Fluent API with conversion methods
/// - Real-world use cases
void main() {
  print('=== SizedFile Advanced Features ===\n');

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
  final baseFile = SizedFile.mb(100);
  print('  Base size: ${baseFile.format()}');
  print('  Double (×2): ${(baseFile * 2).format()}');
  print('  Triple (×3): ${(baseFile * 3).format()}');
  print('  Half (×0.5): ${(baseFile * 0.5).format()}');

  // Division by scalar
  print('\nDivision by Scalar:');
  final largeFile = SizedFile.gb(1);
  print('  Base size: ${largeFile.format()}');
  print('  Half (÷2): ${(largeFile / 2).format()}');
  print('  Quarter (÷4): ${(largeFile / 4).format()}');
  print('  Tenth (÷10): ${(largeFile / 10).format()}');

  // Ratio calculation
  print('\nRatio Calculation with ratioTo():');
  final used = SizedFile.mb(350);
  final total = SizedFile.gb(1);
  final ratio = used.ratioTo(total);
  print('  Used: ${used.format()}');
  print('  Total: ${total.format()}');
  print('  Ratio: ${(ratio * 100).toStringAsFixed(2)}%');

  // Complex calculations
  print('\nComplex Calculations:');
  final doc1 = SizedFile.mb(2.5);
  final doc2 = SizedFile.mb(3.7);
  final doc3 = SizedFile.mb(1.2);
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
    SizedFile.mb(25),
    SizedFile.kb(750),
    SizedFile.gb(1),
    SizedFile.mb(150),
    SizedFile.kb(500),
    SizedFile.mb(75),
  ];

  print('\nFile Collection:');
  for (var i = 0; i < files.length; i++) {
    print('  File ${i + 1}: ${files[i].format()}');
  }

  // Min/Max
  print('\nFinding Min and Max:');
  final minFile = SizedFile.min(files);
  final maxFile = SizedFile.max(files);
  print('  Smallest: ${minFile.format()}');
  print('  Largest: ${maxFile.format()}');

  // Sum
  print('\nCalculating Total:');
  final totalSize = SizedFile.sum(files);
  print('  Total size: ${totalSize.format()}');
  print('  Total in bytes: ${totalSize.inBytes}');

  // Average
  print('\nCalculating Average:');
  final avgSize = SizedFile.average(files);
  print('  Average size: ${avgSize.format()}');
  print('  File count: ${files.length}');

  // Filtered aggregation
  print('\nFiltered Aggregation:');
  final largeFiles = files.where((f) => f > SizedFile.mb(50)).toList();
  final smallFiles = files.where((f) => f <= SizedFile.mb(50)).toList();

  print('  Large files (>50MB): ${largeFiles.length}');
  print('  Large files total: ${SizedFile.sum(largeFiles).format()}');
  print('  Small files (≤50MB): ${smallFiles.length}');
  print('  Small files total: ${SizedFile.sum(smallFiles).format()}');

  print('');
}

void comparableInterface() {
  print('3. COMPARABLE INTERFACE');
  print('=' * 60);

  final unsorted = [
    SizedFile.gb(3),
    SizedFile.kb(500),
    SizedFile.mb(250),
    SizedFile.b(1024),
    SizedFile.gb(1),
    SizedFile.mb(50),
    SizedFile.kb(100),
  ];

  print('\nOriginal Order:');
  for (var i = 0; i < unsorted.length; i++) {
    print('  ${i + 1}. ${unsorted[i].format()}');
  }

  // Ascending sort
  print('\nSorted (Ascending):');
  final ascending = List<SizedFile>.from(unsorted);
  ascending.sort(); // Uses compareTo
  for (var i = 0; i < ascending.length; i++) {
    print('  ${i + 1}. ${ascending[i].format()}');
  }

  // Descending sort
  print('\nSorted (Descending):');
  final descending = List<SizedFile>.from(unsorted);
  descending.sort((a, b) => b.compareTo(a));
  for (var i = 0; i < descending.length; i++) {
    print('  ${i + 1}. ${descending[i].format()}');
  }

  // Direct comparison
  print('\nDirect Comparison:');
  final size1 = SizedFile.mb(500);
  final size2 = SizedFile.gb(1);
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
  final userQuota = SizedFile.gb(100);
  final currentUsage = SizedFile.gb(87.5);
  final remaining = userQuota - currentUsage;
  final usagePercent = currentUsage.ratioTo(userQuota);

  print('\n  User Storage Quota:');
  print('  Quota: ${userQuota.format()}');
  print(
      '  Used: ${currentUsage.format()} (${(usagePercent * 100).toStringAsFixed(1)}%)');
  print('  Remaining: ${remaining.format()}');
  print(
      '  Status: ${usagePercent > 0.9 ? "⚠️ Critical" : usagePercent > 0.75 ? "⚠️ Warning" : "✓ OK"}');

  // Example 2: Backup rotation
  print('\nExample 2: Backup Rotation Strategy');
  final backups = [
    SizedFile.gb(15.2), // Daily
    SizedFile.gb(14.8), // Daily
    SizedFile.gb(45.0), // Weekly
    SizedFile.gb(120.0), // Monthly
  ];

  final totalBackup = SizedFile.sum(backups);
  final avgBackup = SizedFile.average(backups);
  final maxBackup = SizedFile.max(backups);

  print('  Backups: ${backups.length}');
  print('  Total size: ${totalBackup.format()}');
  print('  Average size: ${avgBackup.format()}');
  print('  Largest: ${maxBackup.format()}');
  print('  Storage needed (3x): ${(totalBackup * 3).format()}');

  // Example 3: Video streaming quality
  print('\nExample 3: Video Streaming Quality Selection');
  final videoDuration = 120; // minutes
  final qualities = {
    '4K': SizedFile.gb(videoDuration * 0.15), // ~150 MB/min
    '1080p': SizedFile.gb(videoDuration * 0.06), // ~60 MB/min
    '720p': SizedFile.gb(videoDuration * 0.03), // ~30 MB/min
    '480p': SizedFile.mb(videoDuration * 15.0), // ~15 MB/min
  };

  print('  Video duration: $videoDuration minutes');
  qualities.forEach((quality, size) {
    print('  $quality: ${size.format()}');
  });

  // Example 4: Cost calculation
  print('\nExample 4: Cloud Storage Cost Calculation');
  const costPerGB = 0.023; // $0.023 per GB
  final storedData = SizedFile.sum([
    SizedFile.gb(125), // Documents
    SizedFile.gb(450), // Photos
    SizedFile.gb(280), // Videos
    SizedFile.gb(95), // Backups
  ]);

  final monthlyCost = storedData.inGB * costPerGB;
  final yearlyCost = monthlyCost * 12;

  print('  Total data: ${storedData.format()}');
  print('  Rate: \$${costPerGB}/GB/month');
  print('  Monthly cost: \$${monthlyCost.toStringAsFixed(2)}');
  print('  Yearly cost: \$${yearlyCost.toStringAsFixed(2)}');

  // Example 5: Data transfer estimation
  print('\nExample 5: Data Transfer Time Estimation');
  final dataToTransfer = SizedFile.gb(50);
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
