# flutter_basics

[![Pub Package](https://img.shields.io/pub/v/logger.svg)](https://pub.dev/packages/logger)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Small, easy-to-use, and extensible logger for Flutter and Dart applications. **flutter_basics** provides a production-safe logging utility via `MobigicLogger`, which automatically disables log printing in release/production mode.

Designed and maintained by **Mobigic Technology**.

---

## Features

* Simple and lightweight logging API
* Supports multiple log levels: trace, debug, info, warning, error, fatal
* Pretty and readable log output
* Supports logging objects like `List`, `Map`, and `Set`
* Configurable log filtering and formatting
* Extensible architecture (custom filters, printers, and outputs)
* Works seamlessly with Flutter, Dart, and in-app update workflows

---

## Getting Started

Add the dependency:

```yaml
dependencies:
  flutter_basics: ^latest
```

Import the package:

```dart
import 'package:flutter_basics/flutter_basics.dart';
```

---

## Usage

Use `MobigicLogger` for structured logging across your app. Logs are **automatically disabled in production (release mode)**.

```dart
import 'package:flutter_basics/flutter_basics.dart';

MobigicLogger.debug("Debug message");
MobigicLogger.info("Info message");
MobigicLogger.warning("Warning message");
MobigicLogger.error("Error message");
```

You can also log objects:

```dart
MobigicLogger.info({"status": "success", "version": 1});
```

---

## Log Levels

`MobigicLogger` supports the following log levels:

```dart
MobigicLogger.trace("Trace log");
MobigicLogger.debug("Debug log");
MobigicLogger.info("Info log");
MobigicLogger.warning("Warning log");
MobigicLogger.error("Error log");
MobigicLogger.fatal("Fatal log", error: error, stackTrace: stackTrace);
```

### Production Safety

* ✅ Logs are shown **only in debug/profile mode**
* 🚫 Logs are **automatically disabled in release builds**
* No manual flags required

---

## Configuration Options

When creating a logger, you can pass multiple options:

```dart
var logger = Logger(
  filter: null, // Default LogFilter (logs only in debug mode)
  printer: PrettyPrinter(), // Formats and prints logs
  output: null, // Default LogOutput (prints to console)
);
```

### PrettyPrinter Options

```dart
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // Number of method calls shown
    errorMethodCount: 8, // Method calls when stacktrace is provided
    lineLength: 120, // Width of output
    colors: true, // Enable colors
    printEmojis: true, // Show emojis for log levels
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
```

---

## Auto Detection (IO)

Using `dart:io`, the logger can automatically detect terminal width and color support:

```dart
import 'dart:io' as io;

var logger = Logger(
  printer: PrettyPrinter(
    colors: io.stdout.supportsAnsiEscapes,
    lineLength: io.stdout.terminalColumns,
  ),
);
```

This is recommended unless you are targeting web platforms.

---

## LogFilter

`LogFilter` controls which logs are shown.

The default `DevelopmentFilter`:

* Shows all logs with level >= `Logger.level` in debug mode
* Omits all logs in release mode



## Resources

* 📦 Pub Package
* 📘 Documentation
* 💻 GitHub Repository

---

## Contributing

Contributions are welcome! Please open issues or pull requests to help improve this package.

---

## Acknowledgments

This package was originally created by **Tejeshvi Jagtap** who significantly enhanced its functionality over time.
