enum AudioQualityType {
  low,
  medium,
  high,
  unknown,
}

const _audioQualityUnknown = 0;
const _audioQualityLow = 1;
const _audioQualityMedium = 2;
const _audioQualityHigh = 3;

const _mapType2Int = {
  AudioQualityType.unknown: _audioQualityUnknown,
  AudioQualityType.low: _audioQualityLow,
  AudioQualityType.medium: _audioQualityMedium,
  AudioQualityType.high: _audioQualityHigh,
};

const _mapInt2Type = {
  _audioQualityUnknown: AudioQualityType.unknown,
  _audioQualityLow: AudioQualityType.low,
  _audioQualityMedium: AudioQualityType.medium,
  _audioQualityHigh: AudioQualityType.high,
};

extension AudioQualityTypeExtension on AudioQualityType {
  int get integer => _mapType2Int[this] ?? _audioQualityUnknown;
}

extension AudioQualityIntExtension on int {
  AudioQualityType get audioQualityType => _mapInt2Type[this] ?? AudioQualityType.unknown;
}