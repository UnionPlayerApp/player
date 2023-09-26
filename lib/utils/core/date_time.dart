import 'package:intl/intl.dart';
import 'package:union_player_app/utils/enums/relative_day_type.dart';

const _moscowDiff = Duration(hours: -3);

String formatDateTime(DateTime dateTime) {
  final type = getRelativeDayType(dateTime);
  final pattern = "${getRelativeDayPattern(type)}HH:mm";
  return DateFormat(pattern).format(dateTime);
}

DateTime parseDateTime(String date, String time) {
  try {
    final timeParts = time.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final seconds = int.parse(timeParts[2]);

    final dateParts = date.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    return DateTime.utc(year, month, day, hours, minutes, seconds).add(_moscowDiff).toLocal();
  } catch (error) {
    throw const FormatException('Invalid start date or time format');
  }
}