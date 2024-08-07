import 'package:equatable/equatable.dart';

import '../common/enums/nav_type.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppNavEvent extends AppEvent {
  final NavType navType;

  const AppNavEvent({required this.navType});

  @override
  List<Object> get props => [navType];
}

class AppCustomEvent extends AppEvent {
  final String error;

  const AppCustomEvent({required this.error});

  @override
  List<Object?> get props => [error];
}
