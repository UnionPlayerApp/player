enum RelativeDayType { yesterday, today, tomorrow, any }

RelativeDayType getRelativeDayType(DateTime arg) {
  final now = DateTime.now();
  final nowNorm = DateTime(now.year, now.month, now.day);
  final argNorm = DateTime(arg.year, arg.month, arg.day);
  final diff = argNorm.difference(nowNorm).inDays;

  switch (diff) {
    case -1: return RelativeDayType.yesterday;
    case 0: return RelativeDayType.today;
    case 1: return RelativeDayType.tomorrow;
    default: return RelativeDayType.any;
  }
}

String getRelativeDayPattern(RelativeDayType type) {
  switch (type) {
    case RelativeDayType.any: return "dd.MM ";
    case RelativeDayType.today: return "";
    case RelativeDayType.tomorrow: return "завтра ";
    case RelativeDayType.yesterday: return "вчера ";
  }
}