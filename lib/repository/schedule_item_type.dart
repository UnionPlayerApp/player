const scheduleIndefiniteItemTypeId = 0;
const scheduleMusicItemTypeId = 1;
const scheduleTalkItemTypeId = 2;
const scheduleNewsItemTypeId = 3;

enum ScheduleItemType {
  indefinite,
  music,
  talk,
  news,
}

extension ScheduleItemTypeExtension on ScheduleItemType {

  int get toInt {
    switch (this) {
      case ScheduleItemType.music:
        return scheduleMusicItemTypeId;
      case ScheduleItemType.talk:
        return scheduleTalkItemTypeId;
      case ScheduleItemType.news:
        return scheduleNewsItemTypeId;
      default:
        return scheduleIndefiniteItemTypeId;
    }
  }
}

extension IntExtension on int {
  ScheduleItemType get toScheduleItemType {
    switch (this) {
      case scheduleIndefiniteItemTypeId:
        return ScheduleItemType.indefinite;
      case scheduleMusicItemTypeId:
        return ScheduleItemType.music;
      case scheduleTalkItemTypeId:
        return ScheduleItemType.talk;
      case scheduleNewsItemTypeId:
        return ScheduleItemType.news;
      default:
        return ScheduleItemType.indefinite;
    }
  }
}

