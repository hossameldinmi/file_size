import 'package:sized_file/sized_file.dart';

void main() {
  print('=== SizedFile Equality and Comparison Examples ===\n');

  // Example 1: Basic equality operations
  print('1. Basic Equality Operations');
  print('=' * 40);
  basicEqualityExample();
  print('');

  // Example 2: Comparison operations
  print('2. Comparison Operations');
  print('=' * 40);
  comparisonExample();
  print('');

  // Example 3: Working with collections
  print('3. Collections and Data Structures');
  print('=' * 40);
  collectionsExample();
  print('');

  // Example 4: Sorting and ordering
  print('4. Sorting and Ordering');
  print('=' * 40);
  sortingExample();
  print('');

  // Example 5: Practical use cases
  print('5. Practical Use Cases');
  print('=' * 40);
  practicalUseCases();
  print('');

  // Example 6: Advanced scenarios
  print('6. Advanced Scenarios');
  print('=' * 40);
  advancedScenarios();
}

/// Demonstrates basic equality operations
void basicEqualityExample() {
  // Same size in different units
  final size1KB = SizedFile.kb(1);
  final size1024B = SizedFile.b(1024);
  final sizeMB = SizedFile.mb(0.0009765625);

  print('Same size, different units:');
  print('  1 KB = ${size1KB.inBytes} bytes');
  print('  1024 B = ${size1024B.inBytes} bytes');
  print('  0.0009765625 MB = ${sizeMB.inBytes} bytes');
  print('  Are they equal? ${size1KB == size1024B && size1024B == sizeMB}');
  print('');

  // Hash code consistency
  print('Hash codes (for collections):');
  print('  1 KB hash: ${size1KB.hashCode}');
  print('  1024 B hash: ${size1024B.hashCode}');
  print('  Same hash codes? ${size1KB.hashCode == size1024B.hashCode}');
  print('');

  // Identity vs equality
  final anotherKB = SizedFile.kb(1);
  print('Identity vs Equality:');
  print('  Same object: ${identical(size1KB, size1KB)}');
  print('  Different objects, same size: ${size1KB == anotherKB}');
  print('  Different objects identity: ${identical(size1KB, anotherKB)}');
}

/// Demonstrates comparison operations
void comparisonExample() {
  final small = SizedFile.b(500); // 500 bytes
  final medium = SizedFile.kb(1); // 1 KB = 1024 bytes
  final large = SizedFile.mb(1); // 1 MB = 1048576 bytes
  final xlarge = SizedFile.gb(1); // 1 GB

  print('File sizes for comparison:');
  print('  Small:  ${small.format()} (${small.inBytes} bytes)');
  print('  Medium: ${medium.format()} (${medium.inBytes} bytes)');
  print('  Large:  ${large.format()} (${large.inBytes} bytes)');
  print('  XLarge: ${xlarge.format()} (${xlarge.inBytes} bytes)');
  print('');

  print('Less than comparisons:');
  print('  ${small.format()} < ${medium.format()}: ${small < medium}');
  print('  ${medium.format()} < ${large.format()}: ${medium < large}');
  print('  ${large.format()} < ${xlarge.format()}: ${large < xlarge}');
  print('');

  print('Greater than comparisons:');
  print('  ${xlarge.format()} > ${large.format()}: ${xlarge > large}');
  print('  ${large.format()} > ${medium.format()}: ${large > medium}');
  print('  ${medium.format()} > ${small.format()}: ${medium > small}');
  print('');

  print('Less than or equal:');
  print('  ${medium.format()} <= ${SizedFile.kb(1).format()}: ${medium <= SizedFile.kb(1)}');
  print('  ${small.format()} <= ${medium.format()}: ${small <= medium}');
  print('');

  print('Greater than or equal:');
  print('  ${xlarge.format()} >= ${large.format()}: ${xlarge >= large}');
  print('  ${medium.format()} >= ${medium.format()}: ${medium >= medium}');
}

/// Demonstrates usage with collections
void collectionsExample() {
  // Set operations (eliminates duplicates)
  print('Set operations (removes duplicates):');
  final sizeSet = <SizedFile>{
    SizedFile.kb(1),
    SizedFile.b(1024), // Same as 1 KB
    SizedFile.mb(1),
    SizedFile.kb(1), // Duplicate
    SizedFile.gb(1),
    SizedFile.b(1024), // Another duplicate
  };

  print('  Added 6 sizes, Set contains: ${sizeSet.length} unique sizes');
  for (var size in sizeSet) {
    print('    ${size.format()}');
  }
  print('');

  // Map with SizedFile keys
  print('Map with SizedFile keys:');
  final fileTypeMap = <SizedFile, List<String>>{
    SizedFile.kb(10): ['Text files', 'Small images'],
    SizedFile.mb(5): ['Photos', 'Documents'],
    SizedFile.mb(50): ['Videos', 'Presentations'],
    SizedFile.gb(1): ['Movies', 'Large datasets'],
  };

  fileTypeMap.forEach((size, types) {
    print('  ${size.format().padLeft(8)}: ${types.join(', ')}');
  });
  print('');

  // Checking membership
  print('Checking if specific sizes exist:');
  final searchSize1 = SizedFile.kb(10);
  final searchSize2 = SizedFile.mb(100);
  print('  Contains ${searchSize1.format()}: ${fileTypeMap.containsKey(searchSize1)}');
  print('  Contains ${searchSize2.format()}: ${fileTypeMap.containsKey(searchSize2)}');
}

/// Demonstrates sorting and ordering
void sortingExample() {
  final filesizes = [
    SizedFile.gb(1.5),
    SizedFile.kb(750),
    SizedFile.mb(250),
    SizedFile.b(500),
    SizedFile.tb(1),
    SizedFile.mb(10),
  ];

  print('Original order:');
  for (int i = 0; i < filesizes.length; i++) {
    print('  ${i + 1}. ${filesizes[i].format()}');
  }
  print('');

  // Sort ascending (smallest to largest)
  final sortedAsc = List<SizedFile>.from(filesizes);
  sortedAsc.sort((a, b) => a.inBytes.compareTo(b.inBytes));

  print('Sorted ascending (smallest to largest):');
  for (int i = 0; i < sortedAsc.length; i++) {
    print('  ${i + 1}. ${sortedAsc[i].format()}');
  }
  print('');

  // Sort descending (largest to smallest)
  final sortedDesc = List<SizedFile>.from(filesizes);
  sortedDesc.sort((a, b) => b.inBytes.compareTo(a.inBytes));

  print('Sorted descending (largest to smallest):');
  for (int i = 0; i < sortedDesc.length; i++) {
    print('  ${i + 1}. ${sortedDesc[i].format()}');
  }
  print('');

  // Find min and max
  final minSize = filesizes.reduce((a, b) => a < b ? a : b);
  final maxSize = filesizes.reduce((a, b) => a > b ? a : b);
  print('Statistics:');
  print('  Smallest file: ${minSize.format()}');
  print('  Largest file:  ${maxSize.format()}');
}

/// Demonstrates practical use cases
void practicalUseCases() {
  // File validation
  print('File upload validation:');
  final uploadLimit = SizedFile.mb(10);
  final testFiles = [
    SizedFile.kb(500),
    SizedFile.mb(5),
    SizedFile.mb(15),
    SizedFile.gb(1),
  ];

  for (var fileSize in testFiles) {
    final isValid = fileSize <= uploadLimit;
    final status = isValid ? '✓ ALLOWED' : '✗ REJECTED';
    print('  ${fileSize.format().padLeft(10)} $status');
  }
  print('');

  // Storage capacity planning
  print('Storage capacity planning:');
  final documents = [SizedFile.mb(2), SizedFile.mb(1.5), SizedFile.mb(3)];
  final photos = [SizedFile.mb(5), SizedFile.mb(4), SizedFile.mb(6), SizedFile.mb(3)];
  final videos = [SizedFile.gb(1), SizedFile.mb(800), SizedFile.gb(1.2)];

  final totalDocs = sumSizes(documents);
  final totalPhotos = sumSizes(photos);
  final totalVideos = sumSizes(videos);
  final grandTotal = SizedFile.b(totalDocs.inBytes + totalPhotos.inBytes + totalVideos.inBytes);

  print('  Documents: ${totalDocs.format()} (${documents.length} files)');
  print('  Photos:    ${totalPhotos.format()} (${photos.length} files)');
  print('  Videos:    ${totalVideos.format()} (${videos.length} files)');
  print('  Total:     ${grandTotal.format()}');
  print('');

  // Available space check
  final availableSpace = SizedFile.gb(5);
  final fitsInStorage = grandTotal <= availableSpace;
  print('  Available space: ${availableSpace.format()}');
  print('  Fits in storage: ${fitsInStorage ? "✓ Yes" : "✗ No"}');
  if (!fitsInStorage) {
    final excess = SizedFile.b(grandTotal.inBytes - availableSpace.inBytes);
    print('  Excess amount:   ${excess.format()}');
  }
}

/// Demonstrates advanced scenarios
void advancedScenarios() {
  // File categorization by size
  print('File categorization by size thresholds:');
  final allFiles = [
    SizedFile.kb(50), // Tiny
    SizedFile.kb(800), // Small
    SizedFile.mb(5), // Medium
    SizedFile.mb(50), // Large
    SizedFile.gb(1), // Huge
    SizedFile.kb(10), // Tiny
    SizedFile.mb(25), // Large
  ];

  final tinyThreshold = SizedFile.kb(100);
  final smallThreshold = SizedFile.mb(1);
  final mediumThreshold = SizedFile.mb(10);
  final largeThreshold = SizedFile.mb(100);

  final tiny = allFiles.where((f) => f <= tinyThreshold).toList();
  final small = allFiles.where((f) => f > tinyThreshold && f <= smallThreshold).toList();
  final medium = allFiles.where((f) => f > smallThreshold && f <= mediumThreshold).toList();
  final large = allFiles.where((f) => f > mediumThreshold && f <= largeThreshold).toList();
  final huge = allFiles.where((f) => f > largeThreshold).toList();

  print('  Tiny    (<= ${tinyThreshold.format()}):   ${tiny.length} files - ${tiny.map((f) => f.format()).join(', ')}');
  print(
      '  Small   (<= ${smallThreshold.format()}):    ${small.length} files - ${small.map((f) => f.format()).join(', ')}');
  print(
      '  Medium  (<= ${mediumThreshold.format()}):   ${medium.length} files - ${medium.map((f) => f.format()).join(', ')}');
  print(
      '  Large   (<= ${largeThreshold.format()}):  ${large.length} files - ${large.map((f) => f.format()).join(', ')}');
  print('  Huge    (> ${largeThreshold.format()}):   ${huge.length} files - ${huge.map((f) => f.format()).join(', ')}');
  print('');

  // Priority queue simulation (largest files first)
  print('Priority processing (largest files first):');
  final processingQueue = List<SizedFile>.from(allFiles);
  processingQueue.sort((a, b) => b.inBytes.compareTo(a.inBytes)); // Descending order

  print('  Processing order:');
  for (int i = 0; i < processingQueue.length; i++) {
    print('    ${i + 1}. ${processingQueue[i].format()}');
  }
}

/// Helper function to sum file sizes
SizedFile sumSizes(List<SizedFile> sizes) {
  final totalBytes = sizes.fold<int>(0, (sum, size) => sum + size.inBytes);
  return SizedFile.b(totalBytes);
}
