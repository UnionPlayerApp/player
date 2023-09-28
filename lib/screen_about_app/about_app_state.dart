import 'package:equatable/equatable.dart';

import 'developer_model.dart';

abstract class AboutAppState extends Equatable {
  const AboutAppState();

  @override
  List<Object> get props => [];
}

class AboutAppLoadingState extends AboutAppState {
  const AboutAppLoadingState();
}

class AboutAppLoadedState extends AboutAppState {
  final String versionName;
  final int versionCode;
  final List<DeveloperModel> developers;

  const AboutAppLoadedState({required this.versionName, required this.versionCode, required this.developers});

  @override
  List<Object> get props => [versionName, versionCode, developers];
}
