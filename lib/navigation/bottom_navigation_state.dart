part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  final int currentIndex;

  const BottomNavigationState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

// class CurrentIndexChanged extends BottomNavigationState {
//   final int currentIndex;
//
//   CurrentIndexChanged({required this.currentIndex});
// }
//
// class PageLoading extends BottomNavigationState {
// }
//
// class MainPageLoaded extends BottomNavigationState {
//   MainPageLoaded();
// }
//
// class SchedulePageLoaded extends BottomNavigationState {
//   SchedulePageLoaded();
// }
//
// class FeedbackPageLoaded extends BottomNavigationState {
//   FeedbackPageLoaded();
// }