import 'package:union_player_app/repository/schedule_item_raw.dart';

abstract class IScheduleRepository {
  List<ScheduleItemRaw> getItems();
  ScheduleItemRaw? getCurrentItem();
  Stream stream() async* {}
  void close();
}