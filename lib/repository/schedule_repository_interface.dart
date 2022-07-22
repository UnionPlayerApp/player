import 'package:union_player_app/repository/schedule_repository_event.dart';

abstract class IScheduleRepository {
  Stream<ScheduleRepositoryEvent> stateStream();
  Future <void> start(String url);
  Future <void> stop();
}