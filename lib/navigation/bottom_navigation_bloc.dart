import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_event.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationState(0));

//  int currentIndex = 0;

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    yield BottomNavigationState(event.index);
    // if (event is PageTapped) {
    //   this.currentIndex = event.index;
    //   yield CurrentIndexChanged(currentIndex: this.currentIndex);
    //   yield PageLoading();
    //
    //   if (this.currentIndex == 0) {
    //     yield MainPageLoaded();
    //   }
    //   if (this.currentIndex == 1) {
    //     yield SchedulePageLoaded();
    //   }
    //   if (this.currentIndex == 2) {
    //     yield FeedbackPageLoaded();
    //   }
  }
}
