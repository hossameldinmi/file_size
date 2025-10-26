/// A helper class for converting between bytes and other file size units.
///
/// [ByteConverter] encapsulates the bidirectional conversion logic for a
/// specific unit (KB, MB, GB, TB). Each instance contains two conversion
/// functions:
/// - [toBytes]: Converts from the unit to bytes
/// - [fromBytes]: Converts from bytes to the unit
///
/// This class is used internally by [ConverterStrategy] to handle all
/// unit conversion operations consistently across the sized_file library.
///
/// Example usage (internal):
/// ```dart
/// final kbConverter = ByteConverter(
///   (value) => (value * 1024).round(),
///   (bytes) => bytes / 1024,
/// );
/// print(kbConverter.toBytes(1));    // 1024
/// print(kbConverter.fromBytes(1024)); // 1.0
/// ```
class ByteConverter {
  /// Converts a value from this unit to bytes.
  ///
  /// Takes a numerical value in the unit (e.g., KB, MB) and returns
  /// the equivalent number of bytes as an integer.
  ///
  /// The result is rounded to the nearest integer to ensure accurate
  /// byte representation.
  final int Function(num value) toBytes;

  /// Converts a byte value to this unit.
  ///
  /// Takes an integer number of bytes and returns the equivalent
  /// value in this unit as a double (e.g., bytes to KB, MB).
  ///
  /// Returns a double to preserve precision for fractional unit values.
  final double Function(int bytes) fromBytes;

  /// Creates a [ByteConverter] with the specified conversion functions.
  ///
  /// Parameters:
  /// - [toBytes]: Function to convert from the unit to bytes
  /// - [fromBytes]: Function to convert from bytes to the unit
  ByteConverter(this.toBytes, this.fromBytes);
}
