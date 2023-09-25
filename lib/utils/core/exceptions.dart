class MsgException implements Exception {
  final String message;

  const MsgException(this.message);

  @override
  String toString() => message;
}
