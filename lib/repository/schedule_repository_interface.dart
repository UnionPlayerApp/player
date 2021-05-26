import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';

abstract class IScheduleRepository {
  Stream<ScheduleRepositoryState> stateStream();
  void onStart(String url);
  void onStop();
}