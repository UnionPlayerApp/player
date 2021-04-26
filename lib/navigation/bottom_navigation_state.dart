part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({required this.currentIndex});
}

class PageLoading extends BottomNavigationState {
}

class MainPageLoaded extends BottomNavigationState {
  MainPageLoaded();
}

class SchedulePageLoaded extends BottomNavigationState {
  SchedulePageLoaded();
}

class FeedbackPageLoaded extends BottomNavigationState {
  FeedbackPageLoaded();
}