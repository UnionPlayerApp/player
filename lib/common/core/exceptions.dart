import 'package:webview_flutter/webview_flutter.dart';

class MsgException implements Exception {
  final String message;

  const MsgException(this.message);

  @override
  String toString() => message;
}

class WebResourceException implements Exception {
  final WebResourceError error;

  const WebResourceException({required this.error});

  @override
  String toString() => "WebResourceException => "
      "errorCode: ${error.errorCode}, "
      "description: ${error.description}, "
      "errorType: ${error.errorType}, "
      "isForMainFrame: ${error.isForMainFrame}, "
      "url: ${error.url}";
}
