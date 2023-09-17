import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';
import 'package:union_player_app/player/app_player_handler.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/utils/core/date_time.dart';

import '../utils/constants/constants.dart';
import '../utils/core/image_source_type.dart';
import '../utils/core/string_keys.dart';

// ignore: must_be_immutable
class ListenItemView extends Equatable {
  final DateTime finish;
  final DateTime start;
  final ImageSourceType imageSourceType;
  final String artist;
  final String imageSource;
  final String title;
  final bool isArtistVisible;

  var labelKey = StringKeys.empty;

  ListenItemView._({
    required this.artist,
    required this.finish,
    required this.imageSource,
    required this.imageSourceType,
    required this.isArtistVisible,
    required this.start,
    required this.title,
  });

  factory ListenItemView.fromMediaItem(MediaItem item) {
    final artist = item.artist ?? "";
    final finish = item.duration != null ? item.start.add(item.duration!) : item.start;
    final imageSource = item.artUri == null ? logoImage : item.artUri!.path;
    final imageSourceType = item.artUri == null ? ImageSourceType.assets : ImageSourceType.file;
    final isArtistVisible = item.type.toScheduleItemType == ScheduleItemType.music;

    return ListenItemView._(
      artist: artist,
      finish: finish,
      imageSource: imageSource,
      imageSourceType: imageSourceType,
      isArtistVisible: isArtistVisible,
      start: item.start,
      title: item.title,
    );
  }

  @override
  List<Object?> get props => [start.millisecondsSinceEpoch, finish.millisecondsSinceEpoch];

  @override
  String toString() => "MainItemView, "
      "start = ${formatDateTime(start)} = ${start.millisecondsSinceEpoch}, "
      "finish = ${formatDateTime(finish)} = ${finish.millisecondsSinceEpoch}, "
      "title = $title";
}
