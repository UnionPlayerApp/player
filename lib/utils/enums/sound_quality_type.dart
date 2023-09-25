enum SoundQualityType {
  low,
  medium,
  high,
}

const _soundQualityLow = 0;
const _soundQualityMedium = 1;
const _soundQualityHigh = 2;

const _soundQualityDefault = _soundQualityMedium;
const _soundQualityTypeDefault = SoundQualityType.medium;

const _mapType2Int = {
  SoundQualityType.low: _soundQualityLow,
  SoundQualityType.medium: _soundQualityMedium,
  SoundQualityType.high: _soundQualityHigh,
};

const _mapInt2Type = {
  _soundQualityLow: SoundQualityType.low,
  _soundQualityMedium: SoundQualityType.medium,
  _soundQualityHigh: SoundQualityType.high,
};

extension SoundQualityTypeExtension on SoundQualityType {
  int get integer => _mapType2Int[this] ?? _soundQualityDefault;

}

extension SoundQualityIntExtension on int {
  SoundQualityType get soundQualityType => _mapInt2Type[this] ?? _soundQualityTypeDefault;
}