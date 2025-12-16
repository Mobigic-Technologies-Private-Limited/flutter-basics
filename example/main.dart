import 'package:flutter_basics/flutter_basics.dart';

void main() {
  /// -----------------------------
  /// Console Logging
  /// -----------------------------
  MobigicLogger.debug("Debug message");
  MobigicLogger.info("Info message");
  MobigicLogger.warning("Warning message");
  MobigicLogger.error("Error message");

  /// -----------------------------
  /// Object / Map Logging
  /// -----------------------------
  MobigicLogger.info({
    "status": "success",
    "version": 1,
  });

  /// -----------------------------
  /// Fatal Error Logging
  /// -----------------------------
  try {
    throw Exception("Something went wrong");
  } catch (error, stackTrace) {
    MobigicLogger.error(
      "Fatal error occurred",
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// -----------------------------
  /// File write & upload
  /// (Handled internally by flutter_basics)
  /// -----------------------------
  MobigicLogger.info("Logs are automatically written and can be uploaded later");
}
