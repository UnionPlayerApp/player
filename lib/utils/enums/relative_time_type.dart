import 'string_keys.dart';

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

  bool get isPrevious => this == RelativeTimeType.previous;

  bool get isCurrent => this == RelativeTimeType.current;

  bool get isNext => this == RelativeTimeType.next;
}

RelativeTimeType relativeTimeType(DateTime start, DateTime finish) {
  final now = DateTime.now();
  if (now.isAfter(finish)) return RelativeTimeType.previous;
  if (now.isBefore(start)) return RelativeTimeType.next;
  return RelativeTimeType.current;
}
