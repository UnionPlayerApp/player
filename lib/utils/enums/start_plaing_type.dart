import 'package:union_player_app/utils/constants/constants.dart';

enum StartPlayingType {
  start,
  stop,
  last,
}

const _startPlayingStart = 0;
const _startPlayingStop = 1;
const _startPlayingLast = 2;

const _startPlayingDefault = _startPlayingLast;

const _mapType2Int = {
  StartPlayingType.start: _startPlayingStart,
  StartPlayingType.stop: _startPlayingStop,
  StartPlayingType.last: _startPlayingLast,
};

const _mapInt2Type = {
  _startPlayingStart: StartPlayingType.start,
  _startPlayingStop: StartPlayingType.stop,
  _startPlayingLast: StartPlayingType.last,
};

extension StartPlayingTypeExtension on StartPlayingType {
  int get integer => _mapType2Int[this] ?? _startPlayingDefault;
}

extension StartPlayingIntExtension on int {
  StartPlayingType get startPlayingType => _mapInt2Type[this] ?? defaultStartPlayingType;
}
