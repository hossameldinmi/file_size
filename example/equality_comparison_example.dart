import 'package:file_sized/file_sized.dart';

void main() {
  print('=== FileSize Equality and Comparison Examples ===\n');

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

  // Example 6: Arithmetic operations
  print('6. Arithmetic Operations');
  print('=' * 40);
  arithmeticOperations();
  print('');

  // Example 7: Advanced scenarios
  print('7. Advanced Scenarios');
  print('=' * 40);
  advancedScenarios();
}

/// Demonstrates basic equality operations
void basicEqualityExample() {
  // Same size in different units
  final size1KB = FileSize.kb(1);
  final size1024B = FileSize.b(1024);
  final sizeMB = FileSize.mb(0.0009765625);

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
  final anotherKB = FileSize.kb(1);
  print('Identity vs Equality:');
  print('  Same object: ${identical(size1KB, size1KB)}');
  print('  Different objects, same size: ${size1KB == anotherKB}');
  print('  Different objects identity: ${identical(size1KB, anotherKB)}');
}

/// Demonstrates comparison operations
void comparisonExample() {
  final small = FileSize.b(500); // 500 bytes
  final medium = FileSize.kb(1); // 1 KB = 1024 bytes
  final large = FileSize.mb(1); // 1 MB = 1048576 bytes
  final xlarge = FileSize.gb(1); // 1 GB

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
  print('  ${medium.format()} <= ${FileSize.kb(1).format()}: ${medium <= FileSize.kb(1)}');
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
  final sizeSet = <FileSize>{
    FileSize.kb(1),
    FileSize.b(1024), // Same as 1 KB
    FileSize.mb(1),
    FileSize.kb(1), // Duplicate
    FileSize.gb(1),
    FileSize.b(1024), // Another duplicate
  };

  print('  Added 6 sizes, Set contains: ${sizeSet.length} unique sizes');
  for (var size in sizeSet) {
    print('    ${size.format()}');
  }
  print('');

  // Map with FileSize keys
  print('Map with FileSize keys:');
  final fileTypeMap = <FileSize, List<String>>{
    FileSize.kb(10): ['Text files', 'Small images'],
    FileSize.mb(5): ['Photos', 'Documents'],
    FileSize.mb(50): ['Videos', 'Presentations'],
    FileSize.gb(1): ['Movies', 'Large datasets'],
  };

  fileTypeMap.forEach((size, types) {
    print('  ${size.format().padLeft(8)}: ${types.join(', ')}');
  });
  print('');

  // Checking membership
  print('Checking if specific sizes exist:');
  final searchSize1 = FileSize.kb(10);
  final searchSize2 = FileSize.mb(100);
  print('  Contains ${searchSize1.format()}: ${fileTypeMap.containsKey(searchSize1)}');
  print('  Contains ${searchSize2.format()}: ${fileTypeMap.containsKey(searchSize2)}');
}

/// Demonstrates sorting and ordering
void sortingExample() {
  final filesizes = [
    FileSize.gb(1.5),
    FileSize.kb(750),
    FileSize.mb(250),
    FileSize.b(500),
    FileSize.tb(1),
    FileSize.mb(10),
  ];

  print('Original order:');
  for (int i = 0; i < filesizes.length; i++) {
    print('  ${i + 1}. ${filesizes[i].format()}');
  }
  print('');

  // Sort ascending (smallest to largest)
  final sortedAsc = List<FileSize>.from(filesizes);
  sortedAsc.sort((a, b) => a.inBytes.compareTo(b.inBytes));

  print('Sorted ascending (smallest to largest):');
  for (int i = 0; i < sortedAsc.length; i++) {
    print('  ${i + 1}. ${sortedAsc[i].format()}');
  }
  print('');

  // Sort descending (largest to smallest)
  final sortedDesc = List<FileSize>.from(filesizes);
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
  final uploadLimit = FileSize.mb(10);
  final testFiles = [
    FileSize.kb(500),
    FileSize.mb(5),
    FileSize.mb(15),
    FileSize.gb(1),
  ];

  for (var fileSize in testFiles) {
    final isValid = fileSize <= uploadLimit;
    final status = isValid ? '✓ ALLOWED' : '✗ REJECTED';
    print('  ${fileSize.format().padLeft(10)} $status');
  }
  print('');

  // Storage capacity planning
  print('Storage capacity planning:');
  final documents = [FileSize.mb(2), FileSize.mb(1.5), FileSize.mb(3)];
  final photos = [FileSize.mb(5), FileSize.mb(4), FileSize.mb(6), FileSize.mb(3)];
  final videos = [FileSize.gb(1), FileSize.mb(800), FileSize.gb(1.2)];

  final totalDocs = sumSizes(documents);
  final totalPhotos = sumSizes(photos);
  final totalVideos = sumSizes(videos);
  final grandTotal = FileSize.b(totalDocs.inBytes + totalPhotos.inBytes + totalVideos.inBytes);

  print('  Documents: ${totalDocs.format()} (${documents.length} files)');
  print('  Photos:    ${totalPhotos.format()} (${photos.length} files)');
  print('  Videos:    ${totalVideos.format()} (${videos.length} files)');
  print('  Total:     ${grandTotal.format()}');
  print('');

  // Available space check
  final availableSpace = FileSize.gb(5);
  final fitsInStorage = grandTotal <= availableSpace;
  print('  Available space: ${availableSpace.format()}');
  print('  Fits in storage: ${fitsInStorage ? "✓ Yes" : "✗ No"}');
  if (!fitsInStorage) {
    final excess = FileSize.b(grandTotal.inBytes - availableSpace.inBytes);
    print('  Excess amount:   ${excess.format()}');
  }
}

/// Demonstrates advanced scenarios
void advancedScenarios() {
  // File categorization by size
  print('File categorization by size thresholds:');
  final allFiles = [
    FileSize.kb(50), // Tiny
    FileSize.kb(800), // Small
    FileSize.mb(5), // Medium
    FileSize.mb(50), // Large
    FileSize.gb(1), // Huge
    FileSize.kb(10), // Tiny
    FileSize.mb(25), // Large
  ];

  final tinyThreshold = FileSize.kb(100);
  final smallThreshold = FileSize.mb(1);
  final mediumThreshold = FileSize.mb(10);
  final largeThreshold = FileSize.mb(100);

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
  final processingQueue = List<FileSize>.from(allFiles);
  processingQueue.sort((a, b) => b.inBytes.compareTo(a.inBytes)); // Descending order

  print('  Processing order:');
  for (int i = 0; i < processingQueue.length; i++) {
    print('    ${i + 1}. ${processingQueue[i].format()}');
  }
}

/// Demonstrates arithmetic operations
void arithmeticOperations() {
  // Basic addition
  print('Basic arithmetic operations:');
  final file1 = FileSize.mb(1.5);
  final file2 = FileSize.kb(256);
  final file3 = FileSize.b(1024);

  print('  File 1: ${file1.format()}');
  print('  File 2: ${file2.format()}');
  print('  File 3: ${file3.format()}');

  final sum = file1 + file2 + file3;
  print('  Total:  ${sum.format()} (${sum.inBytes} bytes)');
  print('');

  // Storage capacity management
  print('Storage capacity management:');
  final totalCapacity = FileSize.gb(10);
  final usedSpace = FileSize.gb(7.5);
  final availableSpace = totalCapacity - usedSpace;

  print('  Total capacity:   ${totalCapacity.format()}');
  print('  Used space:       ${usedSpace.format()}');
  print('  Available space:  ${availableSpace.format()}');
  print('');

  // File operations simulation
  print('File operations simulation:');
  var currentUsage = FileSize.mb(500);
  print('  Initial usage: ${currentUsage.format()}');

  // Add some files
  final newFile1 = FileSize.mb(25);
  final newFile2 = FileSize.mb(75);
  currentUsage = currentUsage + newFile1 + newFile2;
  print('  After adding ${newFile1.format()} + ${newFile2.format()}: ${currentUsage.format()}');

  // Remove a file
  final deletedFile = FileSize.mb(30);
  currentUsage = currentUsage - deletedFile;
  print('  After deleting ${deletedFile.format()}: ${currentUsage.format()}');

  // Try to subtract more than available (should clamp to 0)
  final hugeFile = FileSize.gb(10);
  final result = currentUsage - hugeFile;
  print('  Trying to delete ${hugeFile.format()} (larger than current): ${result.format()}');
  print('');

  // Batch operations
  print('Batch file operations:');
  final documentFiles = [
    FileSize.mb(2),
    FileSize.kb(750),
    FileSize.mb(1.5),
    FileSize.kb(500),
  ];

  final imageFiles = [
    FileSize.mb(5),
    FileSize.mb(3.2),
    FileSize.mb(7.8),
    FileSize.mb(2.1),
  ];

  // Calculate totals using addition
  var docTotal = FileSize.b(0);
  for (var doc in documentFiles) {
    docTotal = docTotal + doc;
  }

  var imageTotal = FileSize.b(0);
  for (var img in imageFiles) {
    imageTotal = imageTotal + img;
  }

  final grandTotal = docTotal + imageTotal;

  print('  Documents total: ${docTotal.format()} (${documentFiles.length} files)');
  print('  Images total:    ${imageTotal.format()} (${imageFiles.length} files)');
  print('  Grand total:     ${grandTotal.format()}');
  print('');

  // Chaining operations
  print('Chaining operations:');
  final base = FileSize.mb(100);
  final step = FileSize.mb(25);

  final chain1 = base + step + step - step;
  print('  Base: ${base.format()}');
  print('  Step: ${step.format()}');
  print('  base + step + step - step = ${chain1.format()}');
  print('  Should equal base + step = ${(base + step).format()}');
  print('  Chain result correct: ${chain1 == (base + step)}');
}

/// Helper function to sum file sizes
FileSize sumSizes(List<FileSize> sizes) {
  final totalBytes = sizes.fold<int>(0, (sum, size) => sum + size.inBytes);
  return FileSize.b(totalBytes);
}
