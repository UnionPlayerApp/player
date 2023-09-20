import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/constants/constants.dart';

import '../utils/enums/audio_quality_type.dart';
import 'listen_item_view.dart';

class ListenState extends Equatable {
  final AudioQualityType audioQualityType;
  final ListenItemView itemView;
  final bool isPlaying;

  const ListenState({
    required this.audioQualityType,
    required this.itemView,
    required this.isPlaying,
  });

  factory ListenState.empty() => ListenState(
        audioQualityType: AudioQualityType.unknown,
        itemView: ListenItemView.empty(),
        isPlaying: defaultIsPlaying,
      );

  @override
  List<Object?> get props => [itemView, audioQualityType, isPlaying];

  ListenState copyWith({
    AudioQualityType? audioQualityType,
    ListenItemView? itemView,
    bool? isPlaying,
  }) =>
      ListenState(
        audioQualityType: audioQualityType ?? this.audioQualityType,
        itemView: itemView ?? this.itemView,
        isPlaying: isPlaying ?? this.isPlaying,
      );
}
