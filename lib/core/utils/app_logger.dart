import 'package:logger/logger.dart';

/// Centralized logging utility using the Logger package.
/// Provides consistent log formatting across the app.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String tag, dynamic message) {
    _logger.d('[$tag] $message');
  }

  static void info(String tag, dynamic message) {
    _logger.i('[$tag] $message');
  }

  static void warning(String tag, dynamic message) {
    _logger.w('[$tag] $message');
  }

  static void error(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('[$tag] $message', error: error, stackTrace: stackTrace);
  }
}
