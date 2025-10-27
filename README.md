<h2 align="center">
  Sized File
</h2>

<p align="center">
   <a href="https://github.com/hossameldinmi/sized_file/actions/workflows/dart.yml">
    <img src="https://github.com/hossameldinmi/sized_file/actions/workflows/dart.yml/badge.svg?branch=main" alt="Github action">
  </a>
  <a href="https://codecov.io/github/hossameldinmi/sized_file">
    <img src="https://codecov.io/github/hossameldinmi/sized_file/graph/badge.svg?token=JzTIIzoQOq" alt="Code Coverage">
  </a>
  <a href="https://pub.dev/packages/sized_file">
    <img alt="Pub Package" src="https://img.shields.io/pub/v/sized_file">
  </a>
   <a href="https://pub.dev/packages/sized_file">
    <img alt="Pub Points" src="https://img.shields.io/pub/points/sized_file">
  </a>
  <br/>
  <a href="https://opensource.org/licenses/MIT">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
  </a>
</p>

---

A lightweight and intuitive Dart package for file size conversions and formatting them for human-readable display. Convert between bytes(B), kilobytes(KB), megabytes(MB), gigabytes(GB), and terabytes(TB) using constructors or convenient extension methods. Supports arithmetic operations, comparisons, and localization for a complete file size handling solution.

## Features

- 🔄 **Easy Conversions**: Convert between different size units (B, KB, MB, GB, TB)
- ✨ **Extension Methods**: Create file sizes using intuitive syntax like `5.mb` or `1.gb`
- 🎯 **Mixed Units Support**: Create file sizes from multiple units with `SizedFile.units`
- 📊 **Smart Formatting**: Automatically format sizes with appropriate units
- 🎨 **Customizable**: Configure fraction digits and custom unit postfixes
- 🌍 **Localization Support**: Set custom postfix generators for internationalization
- ⚡ **Lightweight**: Zero dependencies, pure Dart implementation
- 🧮 **Precise Calculations**: Uses 1024 as the divider (binary) for accurate storage size calculations
- ⚖️ **Comparison Support**: Full equality and comparison operators (`==`, `<`, `>`, `<=`, `>=`)
- 🗂️ **Collection Ready**: Works seamlessly with `Set`, `Map`, and sorting operations
- ➕ **Arithmetic Operations**: Add, subtract, multiply, and divide file sizes
- 🔢 **Mathematical Functions**: Built-in `min`, `max`, `sum`, and `average` helpers
- 📐 **Comparable Interface**: Implements `Comparable<SizedFile>` for natural sorting

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sized_file: ^1.3.3
```

Then run:

```bash
dart pub get
```

Or with Flutter:

```bash
flutter pub get
```

## Usage

### Basic Usage

#### Creating SizedFile Instances

You can create a `SizedFile` instance from any unit:

```dart
import 'package:sized_file/sized_file.dart';

// From bytes
final size1 = SizedFile.b(1024);

// From kilobytes
final size2 = SizedFile.kb(1.5);

// From megabytes
final size3 = SizedFile.mb(100);

// From gigabytes
final size4 = SizedFile.gb(2.5);

// From terabytes
final size5 = SizedFile.tb(1);

// From mixed units (combine multiple units)
final size6 = SizedFile.units(
  gb: 2,
  mb: 500,
  kb: 256,
);
```

#### Creating from Mixed Units

When you need to combine multiple units into a single file size, use the `SizedFile.units` factory constructor. This is particularly useful for expressing sizes like "2 GB + 500 MB + 256 KB":

```dart
// Video file: 2 GB + 500 MB + 256 KB
final videoFile = SizedFile.units(
  gb: 2,
  mb: 500,
  kb: 256,
);
print(videoFile.format()); // "2.49 GB"
print(videoFile.inBytes);  // 2672033792

// Database backup: 10 MB + 1024 bytes
final backup = SizedFile.units(
  mb: 10,
  b: 1024,
);
print(backup.format()); // "10.00 MB"

// Media project: 1 GB + 750 MB + 512 KB + 256 bytes
final project = SizedFile.units(
  gb: 1,
  mb: 750,
  kb: 512,
  b: 256,
);
print(project.format()); // "1.73 GB"

// All parameters are optional and default to 0
final onlyMB = SizedFile.units(mb: 500);
print(onlyMB == SizedFile.mb(500)); // true
```

#### Accessing Different Units

Once created, you can access the size in any unit:

```dart
final fileSize = SizedFile.mb(5);

print(fileSize.inBytes);  // 5242880
print(fileSize.inKB);     // 5120.0
print(fileSize.inMB);     // 5.0
print(fileSize.inGB);     // 0.0048828125
print(fileSize.inTB);     // 0.00000476837158203125
```

### Formatting

#### Default Formatting

The `format()` method automatically selects the most appropriate unit:

```dart
print(SizedFile.b(500).format());           // "500 B"
print(SizedFile.b(2048).format());          // "2.00 KB"
print(SizedFile.kb(1536).format());         // "1.50 MB"
print(SizedFile.mb(2048).format());         // "2.00 GB"
```

#### Custom Fraction Digits

Control the number of decimal places:

```dart
final fileSize = SizedFile.kb(1.5);

print(fileSize.format(fractionDigits: 0));  // "2 KB"
print(fileSize.format(fractionDigits: 1));  // "1.5 KB"
print(fileSize.format(fractionDigits: 3));  // "1.500 KB"
```

#### Custom Postfixes

Override the default unit labels for a single format call:

```dart
final fileSize = SizedFile.mb(5);

final customPostfixes = {
  'B': 'bytes',
  'KB': 'kilobytes',
  'MB': 'megabytes',
  'GB': 'gigabytes',
  'TB': 'terabytes',
};

print(fileSize.format(postfixes: customPostfixes));
// Output: "5.00 megabytes"
```

### Localization

Set a global postfix generator for internationalization:

```dart
// Set custom postfixes globally (e.g., for Spanish)
SizedFile.setPostfixesGenerator(() {
  return {
    'B': 'B',
    'KB': 'KB',
    'MB': 'MB',
    'GB': 'GB',
    'TB': 'TB',
  };
});

final fileSize = SizedFile.mb(5);
print(fileSize.format());  // Uses custom postfixes
```

### Extension Methods

The package provides convenient extension methods on `num` (both `int` and `double`) for creating `SizedFile` instances with a more readable syntax:

```dart
import 'package:sized_file/sized_file.dart';

// Create file sizes using extension methods
final document = 500.kb;        // 500 kilobytes
final photo = 2.5.mb;           // 2.5 megabytes
final video = 1.5.gb;           // 1.5 gigabytes
final backup = 2.tb;            // 2 terabytes
final small = 1024.b;           // 1024 bytes

// Use in expressions
final total = 1.gb + 500.mb + 256.kb;
print(total.format()); // "1.49 GB"

// Works with arithmetic
final doubled = 5.mb * 2;
print(doubled.format()); // "10.00 MB"

// Chain operations
final result = 10.gb - 2.gb + 500.mb;
print(result.format()); // "8.49 GB"
```

#### Available Extensions

| Extension | Description | Example | Equivalent To |
|-----------|-------------|---------|---------------|
| `.b` | Bytes | `1024.b` | `SizedFile.b(1024)` |
| `.kb` | Kilobytes | `1.5.kb` | `SizedFile.kb(1.5)` |
| `.mb` | Megabytes | `100.mb` | `SizedFile.mb(100)` |
| `.gb` | Gigabytes | `2.5.gb` | `SizedFile.gb(2.5)` |
| `.tb` | Terabytes | `1.tb` | `SizedFile.tb(1)` |

**Note:** The `.b` extension automatically converts to integer (truncates decimals) since bytes must be whole numbers.

### Arithmetic Operations

The `SizedFile` class supports arithmetic operations for calculating storage totals, quotas, and proportions.

#### Addition and Subtraction

```dart
// Adding file sizes
final document = SizedFile.mb(2);
final spreadsheet = SizedFile.kb(500);
final presentation = SizedFile.kb(1);
final total = document + spreadsheet + presentation;
print(total.format()); // "2.49 MB"

// Subtracting file sizes
final totalStorage = SizedFile.gb(1);
final usedSpace = SizedFile.mb(750);
final available = totalStorage - usedSpace;
print(available.format()); // "274.00 MB"

// Result is clamped to zero if negative
final small = SizedFile.kb(100);
final large = SizedFile.mb(1);
final diff = small - large;
print(diff.format()); // "0 B"
```

#### Multiplication and Division

```dart
// Multiply by scalar to scale sizes
final fileSize = SizedFile.mb(10);
final tripled = fileSize * 3;
print(tripled.format()); // "30.00 MB"

final half = fileSize * 0.5;
print(half.format()); // "5.00 MB"

// Divide by scalar
final total = SizedFile.gb(1);
final quarter = total / 4;
print(quarter.format()); // "256.00 MB"

// Calculate ratio between two sizes
final used = SizedFile.mb(250);
final capacity = SizedFile.gb(1);
final ratio = used.ratioTo(capacity);
print('${(ratio * 100).toStringAsFixed(1)}% used'); // "24.4% used"

// Calculate per-item size
final totalSize = SizedFile.gb(10);
final fileCount = 1000;
final avgSize = totalSize / fileCount;
print(avgSize.format()); // "10.49 MB"
```

### Static Helper Methods

Work with multiple file sizes using built-in utility methods:

```dart
final files = [
  SizedFile.mb(10),
  SizedFile.mb(25),
  SizedFile.mb(15),
  SizedFile.kb(500),
];

// Find minimum and maximum
final smallest = SizedFile.min(files);
print(smallest.format()); // "500.00 KB"

final largest = SizedFile.max(files);
print(largest.format()); // "25.00 MB"

// Calculate total size
final totalSize = SizedFile.sum(files);
print(totalSize.format()); // "50.49 MB"

// Calculate average size
final avgSize = SizedFile.average(files);
print(avgSize.format()); // "12.62 MB"
```

### Comparable Interface

`SizedFile` implements `Comparable<SizedFile>` for seamless sorting:

```dart
final sizes = [
  SizedFile.gb(1),
  SizedFile.kb(100),
  SizedFile.mb(50),
  SizedFile.b(500),
];

// Natural sorting with compareTo
sizes.sort(); // Uses compareTo automatically
print(sizes.first.format()); // "500 B"
print(sizes.last.format()); // "1.00 GB"

// Manual comparison
final result = sizes[0].compareTo(sizes[1]);
// Negative if smaller, 0 if equal, positive if larger
```

### Equality and Comparison

The `SizedFile` class supports equality and comparison operations, making it easy to compare file sizes regardless of the units used to create them.

#### Equality Operations

```dart
final size1 = SizedFile.kb(1);
final size2 = SizedFile.b(1024);
final size3 = SizedFile.mb(0.0009765625);

print(size1 == size2); // true - same size in different units
print(size2 == size3); // true - all represent 1024 bytes
print(size1 == size3); // true

// Works with collections
final uniqueSizes = <SizedFile>{size1, size2, size3};
print(uniqueSizes.length); // 1 - all are equal, so only one unique size

// Use as Map keys
final sizeMap = <SizedFile, String>{
  SizedFile.mb(1): 'Small file',
  SizedFile.gb(1): 'Large file',
};
```

#### Comparison Operations

```dart
final small = SizedFile.kb(500);
final medium = SizedFile.mb(1);
final large = SizedFile.gb(1);

// Less than / Greater than
print(small < medium);  // true
print(large > medium);  // true

// Less than or equal / Greater than or equal
print(small <= SizedFile.kb(500));  // true (equal)
print(medium >= SizedFile.mb(0.5)); // true (greater)

// Sorting file sizes
final sizes = [large, small, medium];
sizes.sort((a, b) => a.inBytes.compareTo(b.inBytes));
// Result: [small, medium, large]

// Find maximum/minimum
final maxSize = sizes.reduce((a, b) => a > b ? a : b);
final minSize = sizes.reduce((a, b) => a < b ? a : b);
print('Largest: ${maxSize.format()}');   // "1.00 GB"
print('Smallest: ${minSize.format()}');  // "500.00 KB"
```

#### Practical Use Cases

```dart
// File size validation
bool isValidFileSize(SizedFile fileSize, SizedFile maxSize) {
  return fileSize <= maxSize;
}

// Storage management
void manageStorage(List<SizedFile> files, SizedFile availableSpace) {
  final totalSize = files.fold<SizedFile>(
    SizedFile.zero,
    (sum, file) => sum + file,
  );
  
  if (totalSize > availableSpace) {
    print('Not enough space! Need ${totalSize.format()}, have ${availableSpace.format()}');
  }
}

// Find files larger than threshold
List<SizedFile> findLargeFiles(List<SizedFile> files, SizedFile threshold) {
  return files.where((file) => file > threshold).toList();
}
```

### Practical Examples

#### Displaying File Upload Progress

```dart
void displayProgress(int uploadedBytes, int totalBytes) {
  final uploaded = SizedFile.b(uploadedBytes);
  final total = SizedFile.b(totalBytes);
  
  print('Uploaded: ${uploaded.format()} of ${total.format()}');
}

displayProgress(524288, 5242880);
// Output: "Uploaded: 512.00 KB of 5.00 MB"
```

#### Comparing File Sizes

```dart
bool isFileTooLarge(int fileSizeBytes, double maxMB) {
  final fileSize = SizedFile.b(fileSizeBytes);
  return fileSize.inMB > maxMB;
}

if (isFileTooLarge(10485760, 5.0)) {
  print('File exceeds 5 MB limit');
}
```

#### Storage Summary

```dart
void printStorageSummary(int usedBytes, int totalBytes) {
  final used = SizedFile.b(usedBytes);
  final total = SizedFile.b(totalBytes);
  final free = SizedFile.b(totalBytes - usedBytes);
  
  final percentUsed = (usedBytes / totalBytes * 100).toStringAsFixed(1);
  
  print('Storage: ${used.format()} / ${total.format()} ($percentUsed% used)');
  print('Available: ${free.format()}');
}

printStorageSummary(107374182400, 268435456000);
// Output:
// Storage: 100.00 GB / 250.00 GB (40.0% used)
// Available: 150.00 GB
```

#### Bandwidth Calculation

```dart
void estimateDownloadTime(int fileSizeBytes, double speedMBps) {
  final fileSize = SizedFile.b(fileSizeBytes);
  final seconds = fileSize.inMB / speedMBps;
  
  print('File size: ${fileSize.format()}');
  print('Speed: ${speedMBps.toStringAsFixed(2)} MB/s');
  print('Estimated time: ${seconds.toStringAsFixed(1)} seconds');
}

estimateDownloadTime(52428800, 10.5);
// Output:
// File size: 50.00 MB
// Speed: 10.50 MB/s
// Estimated time: 4.8 seconds
```

## Examples

For more comprehensive examples, check out the [example](example/) directory which includes:

- **Complete working examples** demonstrating all package features
- **Real-world use cases** like file upload progress, storage summaries, and bandwidth calculations
- **Step-by-step demonstrations** of formatting options and localization
- **Equality and comparison operations** with practical scenarios
- **Collection management** using SizedFile with Set, Map, and sorting

To run the examples:

```bash
cd example
dart pub get

# Run the comprehensive overview
dart run main.dart

# Run the focused equality and comparison examples  
dart run equality_comparison_example.dart
```

See the [example README](example/README.md) for detailed information about each example.

## API Reference

### Constructors

| Constructor               | Description                     | Example             |
| ------------------------- | ------------------------------- | ------------------- |
| `SizedFile.zero`          | Static instance with zero bytes | `SizedFile.zero`    |
| `SizedFile.b(int bytes)`  | Creates instance from bytes     | `SizedFile.b(1024)` |
| `SizedFile.kb(num kb)` | Creates instance from kilobytes | `SizedFile.kb(1.5)` |
| `SizedFile.mb(num mb)` | Creates instance from megabytes | `SizedFile.mb(100)` |
| `SizedFile.gb(num gb)` | Creates instance from gigabytes | `SizedFile.gb(2.5)` |
| `SizedFile.tb(num tb)` | Creates instance from terabytes | `SizedFile.tb(1)`   |
| `SizedFile.units({...})` | Creates from multiple units     | `SizedFile.units(gb: 2, mb: 500)` |

### Properties

| Property  | Type     | Description       |
| --------- | -------- | ----------------- |
| `inBytes` | `int`    | Size in bytes     |
| `inKB`    | `double` | Size in kilobytes |
| `inMB`    | `double` | Size in megabytes |
| `inGB`    | `double` | Size in gigabytes |
| `inTB`    | `double` | Size in terabytes |

### Methods

#### `format({int fractionDigits = 2, Map<String, String>? postfixes})`

Formats the file size with the most appropriate unit.

**Parameters:**
- `fractionDigits` (optional): Number of decimal places (default: 2)
- `postfixes` (optional): Custom unit labels

**Returns:** Formatted string representation

#### `setPostfixesGenerator(Map<String, String> Function() generator)`

Static method to set a global postfix generator for all instances.

**Parameters:**
- `generator`: Function that returns a map of unit postfixes

### Operators

#### Equality Operators

| Operator   | Description               | Example                                |
| ---------- | ------------------------- | -------------------------------------- |
| `==`       | Equality comparison       | `SizedFile.kb(1) == SizedFile.b(1024)` |
| `hashCode` | Hash code for collections | Used automatically in `Set` and `Map`  |

#### Comparison Operators

| Operator | Description           | Example                                   |
| -------- | --------------------- | ----------------------------------------- |
| `<`      | Less than             | `SizedFile.kb(1) < SizedFile.mb(1)`       |
| `<=`     | Less than or equal    | `SizedFile.kb(1) <= SizedFile.b(1024)`    |
| `>`      | Greater than          | `SizedFile.mb(1) > SizedFile.kb(1)`       |
| `>=`     | Greater than or equal | `SizedFile.mb(1) >= SizedFile.b(1048576)` |

#### Arithmetic Operators

| Operator | Description                | Returns     | Example                               |
| -------- | -------------------------- | ----------- | ------------------------------------- |
| `+`      | Addition                   | `SizedFile` | `SizedFile.mb(1) + SizedFile.kb(500)` |
| `-`      | Subtraction (clamped to 0) | `SizedFile` | `SizedFile.mb(2) - SizedFile.kb(500)` |
| `*`      | Multiplication by scalar   | `SizedFile` | `SizedFile.mb(10) * 3`                |
| `/`      | Division by scalar         | `SizedFile` | `SizedFile.mb(30) / 3`                |

#### Other Methods

| Method        | Description                     | Example                                            |
| ------------- | ------------------------------- | -------------------------------------------------- |
| `toString()`  | String representation           | `SizedFile.mb(1.5).toString()` returns `"1.50 MB"` |
| `compareTo()` | Comparable implementation       | `size1.compareTo(size2)` returns int               |
| `ratioTo()`   | Calculate ratio to another size | `used.ratioTo(total)` returns double               |

### Static Methods

| Method                    | Description                  | Example                                    |
| ------------------------- | ---------------------------- | ------------------------------------------ |
| `min(sizes)`              | Returns smallest size from collection | `SizedFile.min([size1, size2, size3])`     |
| `max(sizes)`              | Returns largest size from collection | `SizedFile.max([size1, size2, size3])`     |
| `sum(sizes)`              | Sum of all sizes             | `SizedFile.sum([size1, size2, size3])`     |
| `average(sizes)`          | Average of all sizes         | `SizedFile.average([size1, size2, size3])` |
| `setPostfixesGenerator()` | Set global postfix generator | `SizedFile.setPostfixesGenerator(fn)`      |

## Understanding the Divider

This package uses **1024** as the divider (binary) rather than 1000 (decimal):

- 1 KB = 1,024 bytes
- 1 MB = 1,024 KB = 1,048,576 bytes
- 1 GB = 1,024 MB = 1,073,741,824 bytes
- 1 TB = 1,024 GB = 1,099,511,627,776 bytes

This aligns with how operating systems and storage devices typically report file sizes.

## Testing

The package includes comprehensive unit tests covering:

- All constructors and conversions
- Formatting with various options
- Edge cases and boundary conditions
- Custom postfix generators
- Localization scenarios
- Equality and comparison operations
- Hash code consistency
- Collection behavior (Set, Map)
- Sorting and ordering
- Arithmetic operations (+, -, *, /)
- Static helper methods (min, max, sum, average)
- Comparable interface implementation

Run tests with:

```bash
dart test
```

Or with Flutter:

```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

## Support

If you encounter any issues or have questions:

1. Check the [API Reference](#api-reference) section
2. Look at the [examples](#practical-examples)
3. Open an issue on GitHub

---

Made with ❤️ for the Dart and Flutter community
