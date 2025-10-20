# File Size

A lightweight and intuitive Dart package for handling file size conversions and formatting. Convert between bytes, kilobytes, megabytes, gigabytes, and terabytes with ease, and format them for human-readable display.

## Features

- 🔄 **Easy Conversions**: Convert between different size units (B, KB, MB, GB, TB)
- 📊 **Smart Formatting**: Automatically format sizes with appropriate units
- 🎨 **Customizable**: Configure fraction digits and custom unit postfixes
- 🌍 **Localization Support**: Set custom postfix generators for internationalization
- ⚡ **Lightweight**: Zero dependencies, pure Dart implementation
- 🧮 **Precise Calculations**: Uses 1024 as the divider (binary) for accurate storage size calculations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sized_file: ^1.0.0
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

#### Creating FileSize Instances

You can create a `FileSize` instance from any unit:

```dart
import 'package:sized_file/sized_file.dart';

// From bytes
final size1 = FileSize.b(1024);

// From kilobytes
final size2 = FileSize.kb(1.5);

// From megabytes
final size3 = FileSize.mb(100);

// From gigabytes
final size4 = FileSize.gb(2.5);

// From terabytes
final size5 = FileSize.tb(1);
```

#### Accessing Different Units

Once created, you can access the size in any unit:

```dart
final fileSize = FileSize.mb(5);

print(fileSize.inBytes);  // 5242880
print(fileSize.inKB);     // 5120.0
print(fileSize.inMB);     // 5.0
print(fileSize.inGB);     // 0.0048828125
```

### Formatting

#### Default Formatting

The `format()` method automatically selects the most appropriate unit:

```dart
print(FileSize.b(500).format());           // "500 B"
print(FileSize.b(2048).format());          // "2.00 KB"
print(FileSize.kb(1536).format());         // "1.50 MB"
print(FileSize.mb(2048).format());         // "2.00 GB"
```

#### Custom Fraction Digits

Control the number of decimal places:

```dart
final fileSize = FileSize.kb(1.5);

print(fileSize.format(fractionDigits: 0));  // "2 KB"
print(fileSize.format(fractionDigits: 1));  // "1.5 KB"
print(fileSize.format(fractionDigits: 3));  // "1.500 KB"
```

#### Custom Postfixes

Override the default unit labels for a single format call:

```dart
final fileSize = FileSize.mb(5);

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
FileSize.setPostfixesGenerator(() {
  return {
    'B': 'B',
    'KB': 'KB',
    'MB': 'MB',
    'GB': 'GB',
    'TB': 'TB',
  };
});

final fileSize = FileSize.mb(5);
print(fileSize.format());  // Uses custom postfixes
```

### Practical Examples

#### Displaying File Upload Progress

```dart
void displayProgress(int uploadedBytes, int totalBytes) {
  final uploaded = FileSize.b(uploadedBytes);
  final total = FileSize.b(totalBytes);
  
  print('Uploaded: ${uploaded.format()} of ${total.format()}');
}

displayProgress(524288, 5242880);
// Output: "Uploaded: 512.00 KB of 5.00 MB"
```

#### Comparing File Sizes

```dart
bool isFileTooLarge(int fileSizeBytes, double maxMB) {
  final fileSize = FileSize.b(fileSizeBytes);
  return fileSize.inMB > maxMB;
}

if (isFileTooLarge(10485760, 5.0)) {
  print('File exceeds 5 MB limit');
}
```

#### Storage Summary

```dart
void printStorageSummary(int usedBytes, int totalBytes) {
  final used = FileSize.b(usedBytes);
  final total = FileSize.b(totalBytes);
  final free = FileSize.b(totalBytes - usedBytes);
  
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
  final fileSize = FileSize.b(fileSizeBytes);
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

## API Reference

### Constructors

| Constructor | Description | Example |
|------------|-------------|---------|
| `FileSize.b(int bytes)` | Creates instance from bytes | `FileSize.b(1024)` |
| `FileSize.kb(double kb)` | Creates instance from kilobytes | `FileSize.kb(1.5)` |
| `FileSize.mb(double mb)` | Creates instance from megabytes | `FileSize.mb(100)` |
| `FileSize.gb(double gb)` | Creates instance from gigabytes | `FileSize.gb(2.5)` |
| `FileSize.tb(double tb)` | Creates instance from terabytes | `FileSize.tb(1)` |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `inBytes` | `int` | Size in bytes |
| `inKB` | `double` | Size in kilobytes |
| `inMB` | `double` | Size in megabytes |
| `inGB` | `double` | Size in gigabytes |

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
