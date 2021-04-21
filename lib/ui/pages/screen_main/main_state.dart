import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainState extends Equatable {
  final String stateStr01;
  final String stateStr02;
  final IconData iconData;

  const MainState(
    this.stateStr01,
    this.stateStr02,
    this.iconData,
  );

  @override
  List<Object?> get props => [stateStr01, stateStr02, iconData];
}
