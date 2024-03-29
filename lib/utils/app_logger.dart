import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

const _LOG_TAG = "UPA ->";

void appLog(String message) {
  if (kDebugMode) log(message, name: _LOG_TAG);
}

class AppLogger extends Logger {
  AppLogger() : super();

  void logDebug(String msg) {
    d("$_LOG_TAG $msg");
  }

  void logError(String msg, dynamic error) {
    e("$_LOG_TAG $msg: $error");
  }
}