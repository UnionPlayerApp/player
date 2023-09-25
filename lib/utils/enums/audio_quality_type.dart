import '../constants/constants.dart';

enum AudioQualityType {
  low,
  medium,
  high,
  unknown,
}

const _mapType2Int = {
  AudioQualityType.unknown: audioQualityUnknown,
  AudioQualityType.low: audioQualityLow,
  AudioQualityType.medium: audioQualityMedium,
  AudioQualityType.high: audioQualityHigh,
};

const _mapInt2Type = {
  audioQualityUnknown: AudioQualityType.unknown,
  audioQualityLow: AudioQualityType.low,
  audioQualityMedium: AudioQualityType.medium,
  audioQualityHigh: AudioQualityType.high,
};

extension AudioQualityTypeExtension on AudioQualityType {
  int get integer => _mapType2Int[this] ?? audioQualityUnknown;
}

extension AudioQualityIntExtension on int {
  AudioQualityType get audioQualityType => _mapInt2Type[this] ?? AudioQualityType.unknown;
}