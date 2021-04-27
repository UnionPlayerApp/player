part of 'bottom_navigation_bloc.dart';

class BottomNavigationEvent extends Equatable {
  final int index;

  const BottomNavigationEvent(this.index);

  @override
  List<Object> get props => [index];
}

// class PageTapped extends BottomNavigationEvent {
//   final int index;
//
//   PageTapped({required this.index});
// }