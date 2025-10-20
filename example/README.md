# File Size Examples

This folder contains example code demonstrating how to use the `sized_file` package.

## Running the Examples

To run the examples:

```bash
# Navigate to the example directory
cd example

# Get dependencies
dart pub get

# Run the main example
dart run example.dart
```

## What's Included

The `example.dart` file demonstrates:

1. **Creating SizedFile instances** from different units (B, KB, MB, GB, TB)
2. **Accessing values** in different units
3. **Formatting** with custom fraction digits
4. **Custom postfixes** for individual format calls
5. **Global postfix generator** for localization
6. **File upload progress** simulation
7. **Storage summary** display
8. **File size validation** against limits
9. **Bandwidth calculation** and download time estimation
10. **Automatic unit selection** based on size

## Quick Examples

### Basic Usage

```dart
import 'package:sized_file/sized_file.dart';

void main() {
  // Create from megabytes
  final fileSize = SizedFile.mb(5);
  
  // Format for display
  print(fileSize.format()); // "5.00 MB"
  
  // Access in different units
  print(fileSize.inBytes); // 5242880
  print(fileSize.inKB);    // 5120.0
}
```

### Custom Formatting

```dart
final size = SizedFile.kb(1.5);

// Different fraction digits
print(size.format(fractionDigits: 0)); // "2 KB"
print(size.format(fractionDigits: 3)); // "1.500 KB"

// Custom postfixes
final custom = {'B': 'bytes', 'KB': 'kilobytes', 'MB': 'megabytes', 'GB': 'gigabytes'};
print(size.format(postfixes: custom)); // "1.50 kilobytes"
```
