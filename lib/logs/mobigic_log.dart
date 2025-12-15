import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MobigicLogger {
  /// Controlled by app OR --dart-define
  static bool allowLogging = const bool.fromEnvironment(
    'allowLogging',
    defaultValue: true,
  );
  static late Logger _logger;

  static const String tag = "[MOBIGIC]";
  static const String subTag = "[LogData]";

  static bool _initialized = false;

  // Plain-text file used for quick open/read/share
  static File? _textLogFile;
  static const String _textLogDirName = "MobigicLogs";
  static const String _textLogFileName = "mobigic_logs.txt";

  /// ---------------------------------------------------------------
  /// INTERNAL INITIALIZER (Auto-calls before writing logs)
  /// ---------------------------------------------------------------
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        noBoxingByDefault: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      level: Level.all,
    );

    await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE,
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["app", "device", "errors", subTag],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: _textLogDirName,
      logsExportDirectoryName: "$_textLogDirName/Exported",
      isDebuggable: true,
      debugFileOperations: true,
      logsRetentionPeriodInDays: 7,
      zipsRetentionPeriodInDays: 7,
    );

    await _ensureTextLogFileExists();

    _initialized = true;
  }

  /// ----------------------------------------------------------------
  /// Create plain-text log file and parent dir if not present
  /// ----------------------------------------------------------------
  static Future<void> _ensureTextLogFileExists() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logsDir = Directory(p.join(dir.path, _textLogDirName));
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      final file = File(p.join(logsDir.path, _textLogFileName));
      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      _textLogFile = file;
    } catch (e) {
      // ignore initialization errors (you may want to surface them)
      _textLogFile = null;
    }
  }

  /// ----------------------------------------------------------------
  /// Append a line to the plain-text file (timestamped)
  /// ----------------------------------------------------------------
  static Future<void> _appendToTextFile(String message) async {
    if (_textLogFile == null) {
      await _ensureTextLogFileExists();
      if (_textLogFile == null) return;
    }

    final ts = DateTime.now().toIso8601String();
    final line = '[$ts] $message\n';
    try {
      await _textLogFile!.writeAsString(
        line,
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      // ignore write errors (or handle/log them)
    }
  }

  /// ----------------------------------------------------------------
  /// CENTRAL LOG FUNCTION
  /// ----------------------------------------------------------------
  static Future<void> _log(String st, String message) async {
    if (!allowLogging || kReleaseMode) return;

    await ensureInitialized();

    final fullMsg = "$tag $st $message";

    // ====== NEW: Console logging (same as LoggerService) ======
    switch (st) {
      case "[INFO]":
        _logger.i(fullMsg);
        break;
      case "[WARNING]":
        _logger.w(fullMsg);
        break;
      case "[ERROR]":
        _logger.e(fullMsg);
        break;
      case "[WTF]":
        _logger.f(fullMsg);
        break;
      default:
        _logger.d(fullMsg);
    }

    // Existing flutter_logs output
    await FlutterLogs.logThis(tag: tag, subTag: st, logMessage: message);

    // Also write to text file
    await _appendToTextFile('$st $message');
  }

  /// ----------------------------------------------------------------
  /// PUBLIC LOG METHODS
  /// ----------------------------------------------------------------
  static Future<void> debug(Object log) async => _log(subTag, "$log");
  static Future<void> info(Object log) async => _log("[INFO]", "$log");
  static Future<void> warning(Object log) async => _log("[WARNING]", "$log");
  static Future<void> error(
    Object log, {
    Object? error,
    StackTrace? stackTrace,
  }) async => _log("[ERROR]", "$log\n$error\n$stackTrace");
  static Future<void> wtf(Object log) async => _log("[WTF]", "$log");

  /// ----------------------------------------------------------------
  /// Helpers to open/read/clear the plain-text log file
  /// ----------------------------------------------------------------

  /// Returns absolute path to the plain-text log file (or null if not available)
  static Future<String?> getLogFilePath() async {
    if (!_initialized) await ensureInitialized();
    return _textLogFile?.path;
  }

  /// Opens the plain-text log file with the platform default viewer.
  /// Returns the OpenResult from open_file.
  static Future<OpenResult?> openLogFile() async {
    if (!_initialized) await ensureInitialized();
    if (_textLogFile == null) return null;
    try {
      return await OpenFile.open(_textLogFile!.path);
    } catch (e) {
      return null;
    }
  }

  /// Reads the whole plain-text log into a string (useful to show in-app)
  static Future<String> readAllLogs() async {
    if (!_initialized) await ensureInitialized();
    if (_textLogFile == null) return '';
    try {
      return await _textLogFile!.readAsString();
    } catch (e) {
      return '';
    }
  }

  /// Clears the plain-text log file contents (keeps the file)
  static Future<void> clearLogs() async {
    if (!_initialized) await ensureInitialized();
    if (_textLogFile == null) return;
    try {
      await _textLogFile!.writeAsString('', flush: true);
    } catch (e) {
      // ignore
    }
  }

  /// Copies the current plain-text log file to [destFile] (useful for export)
  /// Example usage from UI: copyTo(File('/storage/emulated/0/Download/mobigic_export.txt'))
  static Future<File?> copyLogTo(File destFile) async {
    if (!_initialized) await ensureInitialized();
    if (_textLogFile == null) return null;
    try {
      return await _textLogFile!.copy(destFile.path);
    } catch (e) {
      return null;
    }
  }
}
