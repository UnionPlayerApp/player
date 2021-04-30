import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

class MainEvent extends Equatable {
  final bool playingState;
  final ProcessingState processingState;

  MainEvent(this.playingState, this.processingState);

  @override
  List<Object?> get props => [playingState, processingState];
}