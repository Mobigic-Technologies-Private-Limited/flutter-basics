Here is a complete README.md for your package flutter_basics, including logging, file write, and upload logs.
You can copy-paste this directly into your repository.

flutter_basics




A lightweight, production-safe utility package for Flutter applications providing structured logging, file-based log storage, and manual log upload support.

Designed and maintained by Mobigic Technology.

✨ Features

✅ Production-safe logger (MobigicLogger)

🧾 Supports log levels: trace, debug, info, warning, error, fatal

🚫 Automatically disables console logs in release mode

💾 Persistent file-based logging using LogService

☁️ Manual log upload support

🧹 Clear logs after successful upload

📱 Works with Flutter mobile apps (Android & iOS)

🔄 Useful for crash tracking & in-app update debugging

📦 Installation

Add the dependency in pubspec.yaml:

dependencies:
  flutter_basics: ^latest


Run:

flutter pub get

📥 Import
import 'package:flutter_basics/flutter_basics.dart';

🚀 Usage
Console Logging (MobigicLogger)
MobigicLogger.debug("Debug message");
MobigicLogger.info("Info message");
MobigicLogger.warning("Warning message");
MobigicLogger.error("Error message");


Log objects easily:

MobigicLogger.info({
  "status": "success",
  "version": 1,
});

🧱 Log Levels
MobigicLogger.trace("Trace log");
MobigicLogger.debug("Debug log");
MobigicLogger.info("Info log");
MobigicLogger.warning("Warning log");
MobigicLogger.error("Error log");
MobigicLogger.fatal(
  "Fatal error",
  error: error,
  stackTrace: stackTrace,
);

🔒 Production Safety

✅ Logs print only in debug/profile

🚫 No console logs in release builds

⚙️ No manual flags required

💾 File-Based Logging (LogService)

LogService allows you to persist logs into a local file for later upload or debugging.

Write Logs to File
await LogService.writeLog("Home screen opened");
await LogService.writeLog("User clicked submit button");
await LogService.writeLog("CRASH ERROR: API failed");


Each entry is saved with a timestamp:

2025-12-16T10:30:15.432 -> Home screen opened

☁️ Upload Logs

Useful for Report Issue, Support, or Crash Recovery flows.

Future<void> uploadLogs() async {
  final file = await LogService.getLogFileToUpload();

  try {
    await LogService.writeLog("Manual log upload initiated by user");

    await MobigicHelper.uploadFile(file);

    // Clear logs after successful upload
    await file.writeAsString("");

    MobigicLogger.info("Logs uploaded & cleared successfully");
  } catch (e) {
    await LogService.writeLog("Upload failed: $e");
    MobigicLogger.error("Log upload failed", error: e);
  }
}

📂 Log File Location




This file can be:

Uploaded to backend

Shared with support teams

Attached to crash reports

✅ Recommended Usage
Purpose	Tool
Debug / Development logs	MobigicLogger
Production persistent logs	LogService
Manual issue reporting	Log upload
Crash diagnostics	File logs
🧩 Configuration (Advanced)

You can customize logger behavior if needed:

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
);

🤝 Contributing

Contributions are welcome!

Open issues for bugs or suggestions

Submit pull requests for improvements

🏆 Acknowledgments

This package was originally created and enhanced by
Tejeshvi Jagtap, focusing on real-world production debugging needs and scalable Flutter architecture.

📜 License

MIT License © Mobigic Technology