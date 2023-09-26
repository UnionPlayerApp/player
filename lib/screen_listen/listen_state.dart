import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/constants/constants.dart';

import '../utils/enums/sound_quality_type.dart';
import 'listen_item_view.dart';

class ListenState extends Equatable {
  final SoundQualityType soundQualityType;
  final ListenItemView itemView;
  final bool isPlaying;

  const ListenState({
    required this.soundQualityType,
    required this.itemView,
    required this.isPlaying,
  });

  factory ListenState.empty() => ListenState(
        soundQualityType: defaultSoundQualityType,
        itemView: ListenItemView.empty(),
        isPlaying: defaultIsPlaying,
      );

  @override
  List<Object?> get props => [itemView, soundQualityType, isPlaying];

  ListenState copyWith({
    SoundQualityType? soundQualityType,
    ListenItemView? itemView,
    bool? isPlaying,
  }) =>
      ListenState(
        soundQualityType: soundQualityType ?? this.soundQualityType,
        itemView: itemView ?? this.itemView,
        isPlaying: isPlaying ?? this.isPlaying,
      );
}
