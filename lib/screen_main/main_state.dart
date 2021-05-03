import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final String stateStr01;
  final String stateStr02;

  const MainState(
    this.stateStr01,
    this.stateStr02,
  );

  @override
  List<Object?> get props => [stateStr01, stateStr02];
}
