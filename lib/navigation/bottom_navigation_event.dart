part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  PageTapped({required this.index});
}