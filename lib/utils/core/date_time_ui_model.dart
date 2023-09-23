import 'package:intl/intl.dart';

import 'relative_day_type.dart';
import 'string_keys.dart';

class DateTimeUiModel {
  final String time;
  final String? date;
  final StringKeys? dateLabel;

  const DateTimeUiModel._({required this.time, required this.date, required this.dateLabel});

  factory DateTimeUiModel.fromDateTime(DateTime dateTime) {
    final dateType = getRelativeDayType(dateTime);

    final String? date;
    final StringKeys? dateLabel;

    switch (dateType) {
      case RelativeDayType.tomorrow:
        date = null;
        dateLabel = StringKeys.tomorrow;
        break;
      case RelativeDayType.yesterday:
        date = null;
        dateLabel = StringKeys.yesterday;
        break;
      case RelativeDayType.any:
        date = DateFormat("dd.MM").format(dateTime);
        dateLabel = null;
        break;
      default:
        date = null;
        dateLabel = null;
        break;
    }

    return DateTimeUiModel._(
      time: DateFormat("HH:mm").format(dateTime),
      date: date,
      dateLabel: dateLabel,
    );
  }
}
