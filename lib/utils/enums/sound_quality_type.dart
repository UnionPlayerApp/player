import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

enum SoundQualityType {
  low,
  medium,
  high,
}

const _soundQualityLow = 0;
const _soundQualityMedium = 1;
const _soundQualityHigh = 2;

const _soundQualityDefault = _soundQualityMedium;
const _soundQualityTypeDefaultLabelKey = StringKeys.settingsQualityMedium;

const _mapType2Int = {
  SoundQualityType.low: _soundQualityLow,
  SoundQualityType.medium: _soundQualityMedium,
  SoundQualityType.high: _soundQualityHigh,
};

const _mapType2StringKeys = {
  SoundQualityType.low: StringKeys.settingsQualityLow,
  SoundQualityType.medium: StringKeys.settingsQualityMedium,
  SoundQualityType.high: StringKeys.settingsQualityHigh,
};

const _mapInt2Type = {
  _soundQualityLow: SoundQualityType.low,
  _soundQualityMedium: SoundQualityType.medium,
  _soundQualityHigh: SoundQualityType.high,
};

extension SoundQualityTypeExtension on SoundQualityType {
  int get integer => _mapType2Int[this] ?? _soundQualityDefault;

  StringKeys get labelKey => _mapType2StringKeys[this] ?? _soundQualityTypeDefaultLabelKey;
}

extension SoundQualityIntExtension on int {
  SoundQualityType get soundQualityType => _mapInt2Type[this] ?? defaultSoundQualityType;
}
