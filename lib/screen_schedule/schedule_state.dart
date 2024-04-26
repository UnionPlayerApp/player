import 'package:equatable/equatable.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';

abstract class ScheduleState extends Equatable {
  final String? errorText;

  const ScheduleState({this.errorText});

  ScheduleState copyWithError({required String errorText});

  @override
  List<Object> get props => [errorText ?? ""];
}

class ScheduleLoadingState extends ScheduleState {
  const ScheduleLoadingState({super.errorText});

  @override
  ScheduleLoadingState copyWithError({required String errorText}) => ScheduleLoadingState(errorText: errorText);
}

class ScheduleLoadedState extends ScheduleState {
  final List<ScheduleItemView> items;
  final int currentIndex;

  const ScheduleLoadedState({
    required this.items,
    required this.currentIndex,
    super.errorText,
  });

  @override
  ScheduleLoadedState copyWithError({required String errorText}) => ScheduleLoadedState(
        items: items,
        currentIndex: currentIndex,
        errorText: errorText,
      );

  @override
  List<Object> get props => super.props + [items, currentIndex];
}
