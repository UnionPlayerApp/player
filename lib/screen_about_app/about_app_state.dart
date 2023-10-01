import 'package:union_player_app/common/enums/string_keys.dart';

import 'developer_model.dart';

abstract class AboutAppState {
  const AboutAppState();
}

class AboutAppLoadingState extends AboutAppState {
  const AboutAppLoadingState();
}

class AboutAppLoadedState extends AboutAppState {
  final String version;
  final String buildNumber;
  final List<DeveloperModel> developers;
  final StringKeys? toastKey;
  final String? toastParam;

  const AboutAppLoadedState({
    required this.version,
    required this.buildNumber,
    required this.developers,
    this.toastKey,
    this.toastParam,
  });

  AboutAppLoadedState copyWith({StringKeys? toastKey, String? toastParam}) => AboutAppLoadedState(
        version: version,
        buildNumber: buildNumber,
        developers: developers,
        toastKey: toastKey,
        toastParam: toastParam,
      );
}
