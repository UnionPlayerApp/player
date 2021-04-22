import 'package:logger/logger.dart';

const _LOG_TAG = "UPA ->";

class AppLogger extends Logger {
  AppLogger() : super();

  void logDebug(String msg) {
    d("$_LOG_TAG $msg");
  }

  void logError(String msg, Error error) {
    e("$_LOG_TAG $msg: $error");
  }
}