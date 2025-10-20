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
  final customPostfixes = {'B': 'bytes', 'KB': 'kilobytes', 'MB': 'megabytes', 'GB': 'gigabytes', 'TB': 'terabytes'};
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

  // Example 6: File upload progress simulation
  print('6. File upload progress:');
  simulateFileUpload(5242880); // 5 MB
  print('');

  // Example 7: Storage summary
  print('7. Storage summary:');
  printStorageSummary(107374182400, 268435456000);
  print('');

  // Example 8: File size validation
  print('8. File size validation:');
  validateSizedFile(2097152, 5.0); // 2 MB file, 5 MB limit
  validateSizedFile(10485760, 5.0); // 10 MB file, 5 MB limit
  print('');

  // Example 9: Bandwidth calculation
  print('9. Bandwidth calculation:');
  estimateDownloadTime(52428800, 10.5); // 50 MB file at 10.5 MB/s
  print('');

  // Example 10: Different size thresholds
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

/// Validates if a file size is within the allowed limit
void validateSizedFile(int fileSizeBytes, double maxMB) {
  final fileSize = SizedFile.b(fileSizeBytes);
  final maxSize = SizedFile.mb(maxMB);

  print(
    'File: ${fileSize.format()} - Limit: ${maxSize.format()} - ${fileSize.inMB <= maxMB ? "✓ Valid" : "✗ Too large"}',
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
