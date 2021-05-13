String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return duration.compareTo(Duration(hours: 1)) < 0
      ? "$twoDigitMinutes:$twoDigitSeconds"
      : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

Duration parseDuration(String time) {
  final parts = time.split(':');
  try {
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  } catch (error) {
    throw FormatException('Invalid duration element format');
  }
}