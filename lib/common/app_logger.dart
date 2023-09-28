import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

const _logTag = "UPA ->";

void appLog(String message) {
  if (kDebugMode) log(message, name: _logTag);
}

class AppLogger extends Logger {
  AppLogger() : super();

  void logDebug(String msg) {
    d("$_logTag $msg");
  }

  void logError(String msg, dynamic error) {
    e("$_logTag $msg: $error");
  }
}