import 'package:equatable/equatable.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';

class MainEvent extends Equatable {
  final bool isScheduleLoaded;
  final List<ScheduleItemRaw> scheduleItems;
  final String loadingError;

  MainEvent(this.isScheduleLoaded,
      {this.scheduleItems = const [], this.loadingError = ""});

  @override
  List<Object?> get props => [isScheduleLoaded, scheduleItems, loadingError];
}
