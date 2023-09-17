import 'package:equatable/equatable.dart';

import '../utils/enums/audio_quality_type.dart';
import 'listen_item_view.dart';

class ListenState extends Equatable {
  final AudioQualityType audioQualityType;
  final List<ListenItemView> items;
  final int currentIndex;

  const ListenState({
    required this.audioQualityType,
    required this.items,
    required this.currentIndex,
  });

  factory ListenState.empty() => const ListenState(
        audioQualityType: AudioQualityType.unknown,
        items: [],
        currentIndex: 0,
      );

  @override
  List<Object?> get props => [items, currentIndex, audioQualityType];

  ListenState copyWith({
    AudioQualityType? audioQualityType,
    List<ListenItemView>? items,
    int? currentIndex,
  }) =>
      ListenState(
        audioQualityType: audioQualityType ?? this.audioQualityType,
        items: items ?? this.items,
        currentIndex: currentIndex ?? this.currentIndex,
      );
}
