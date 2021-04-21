part of 'bottom_navigation_bloc.dart';

const LOG_TAG = "UPA -> ";
late Logger logger = Logger();

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends BottomNavigationEvent {
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  PageTapped({required this.index});
}