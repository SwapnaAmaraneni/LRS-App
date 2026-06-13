import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;
  final Logger _loggerNoStack;
  final Logger _simpleLogger;

  AppLogger()
      : _logger = Logger(
          printer: PrettyPrinter(),
        ),
        _loggerNoStack = Logger(
          printer: PrettyPrinter(methodCount: 0),
        ),
        _simpleLogger = Logger(
          printer: SimplePrinter(colors: true),
        );

  void logDebug(String message) {
    if (!kReleaseMode) _logger.d(message);
  }

  void logInfo(String message) {
    if (!kReleaseMode) _loggerNoStack.i(message);
  }

  void logWarning(String message) {
    if (!kReleaseMode) _loggerNoStack.w(message);
  }

  void logError(String message, {dynamic error}) {
    if (!kReleaseMode) _logger.e(message, error: error);
  }

  void logTrace(dynamic message) {
    if (!kReleaseMode) _loggerNoStack.t(message);
  }

  void logSimpleTrace(String message) {
    if (!kReleaseMode) _simpleLogger.t(message);
  }
}
