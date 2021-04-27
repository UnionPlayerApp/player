part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class AppFabPressedEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppNavPressedEvent extends AppEvent {
  final int navIndex;

  AppNavPressedEvent(this.navIndex);

  @override
  List<Object> get props => [navIndex];
}


