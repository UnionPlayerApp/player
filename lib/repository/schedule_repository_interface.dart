import 'package:union_player_app/repository/schedule_repository_event.dart';

abstract interface class IScheduleRepository {
  Stream<ScheduleRepositoryEvent> stateStream();
  Future <void> start(String url);
  Future <void> stop();
}