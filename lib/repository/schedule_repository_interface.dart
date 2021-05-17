import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';

abstract class IScheduleRepository {
  List<ScheduleItemRaw> getItems();
  ScheduleItemRaw? getCurrentItem();
  Stream<ScheduleRepositoryState> stream() async* {}
  void close();
}