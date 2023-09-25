import 'package:equatable/equatable.dart';

import '../utils/enums/nav_type.dart';

class AppState extends Equatable {
  final NavType navType;
  final String message;

  const AppState({
    required this.navType,
    this.message = "",
  });

  factory AppState.defaultState() => const AppState(navType: NavType.listen);

  @override
  List<Object> get props => [navType, message];

  AppState copyWith({
    NavType? navType,
    String? message,
  }) =>
      AppState(
        navType: navType ?? this.navType,
        message: message ?? this.message,
      );
}
