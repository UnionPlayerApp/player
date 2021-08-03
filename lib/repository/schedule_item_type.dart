const SCHEDULE_INDEFINITE_ITEM_TYPE_ID = 0;
const SCHEDULE_MUSIC_ITEM_TYPE_ID = 1;
const SCHEDULE_TALK_ITEM_TYPE_ID = 2;
const SCHEDULE_NEWS_ITEM_TYPE_ID = 3;

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
        return SCHEDULE_MUSIC_ITEM_TYPE_ID;
      case ScheduleItemType.talk:
        return SCHEDULE_TALK_ITEM_TYPE_ID;
      case ScheduleItemType.news:
        return SCHEDULE_NEWS_ITEM_TYPE_ID;
      default:
        return SCHEDULE_INDEFINITE_ITEM_TYPE_ID;
    }
  }
}

extension IntExtension on int {
  ScheduleItemType get toScheduleItemType {
    switch (this) {
      case SCHEDULE_INDEFINITE_ITEM_TYPE_ID:
        return ScheduleItemType.indefinite;
      case SCHEDULE_MUSIC_ITEM_TYPE_ID:
        return ScheduleItemType.music;
      case SCHEDULE_TALK_ITEM_TYPE_ID:
        return ScheduleItemType.talk;
      case SCHEDULE_NEWS_ITEM_TYPE_ID:
        return ScheduleItemType.news;
      default:
        return ScheduleItemType.indefinite;
    }
  }
}

