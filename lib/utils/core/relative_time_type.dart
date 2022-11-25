import '../localizations/string_translation.dart';

enum RelativeTimeType { previous, current, next }

extension RelativeTimeTypeExtension on RelativeTimeType {
  StringKeys get stringKey {
    switch (this) {
      case RelativeTimeType.previous:
        return StringKeys.prevLabel;
      case RelativeTimeType.current:
        return StringKeys.currLabel;
      case RelativeTimeType.next:
        return StringKeys.nextLabel;
    }
  }
}

RelativeTimeType relativeTimeType(DateTime start, DateTime finish) {
  final now = DateTime.now();
  if (now.isAfter(finish)) return RelativeTimeType.previous;
  if (now.isBefore(start)) return RelativeTimeType.next;
  return RelativeTimeType.current;
}
