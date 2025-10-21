# File Size Examples

This folder contains example code demonstrating how to use the `sized_file` package.

## Running the Examples

To run the examples:

```bash
# Navigate to the example directory
cd example

# Get dependencies
dart pub get

# Run the main example (comprehensive overview)
dart run main.dart

# Run the equality and comparison focused example
dart run equality_comparison_example.dart
```

## Example Files

### `main.dart` - Comprehensive Overview
The main example demonstrates:

1. **Creating SizedFile instances** from different units (B, KB, MB, GB, TB)
2. **Accessing values** in different units
3. **Formatting** with custom fraction digits
4. **Custom postfixes** for individual format calls
5. **Global postfix generator** for localization
6. **Equality and comparison operations** - NEW!
7. **File collection management** - NEW!
8. **File upload progress** simulation
9. **Storage summary** display
10. **File size validation** with comparison operators
11. **Bandwidth calculation** and download time estimation
12. **Automatic unit selection** based on size

### `equality_comparison_example.dart` - Equality & Comparison Focus
A dedicated example focusing on the new equality and comparison features:

1. **Basic Equality Operations** - Same size in different units, hash codes
2. **Comparison Operations** - All comparison operators (<, <=, >, >=)
3. **Collections** - Using SizedFile with Set, Map, and other data structures
4. **Sorting and Ordering** - Sorting files by size, finding min/max
5. **Practical Use Cases** - File validation, storage planning
6. **Advanced Scenarios** - File categorization, priority processing

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
