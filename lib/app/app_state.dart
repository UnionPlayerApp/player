import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

class AppState extends Equatable {
  final AudioPlayer _player;

  const AppState(this._player);

  @override
  List<Object?> get props => [_player];
}
