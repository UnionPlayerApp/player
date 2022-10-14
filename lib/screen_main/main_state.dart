import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

import 'main_item_view.dart';

class MainState extends Equatable {
  final ImageSourceType imageSourceType;
  final List<MainItemView> items;
  final String imageSource;
  final String itemArtist;
  final String itemTitle;
  final StringKeys itemLabelKey;
  final bool isArtistVisible;
  final bool isScheduleLoaded;
  final bool isTitleVisible;

  const MainState({
    this.imageSource = "",
    this.imageSourceType = ImageSourceType.none,
    this.isArtistVisible = false,
    this.isScheduleLoaded = false,
    this.isTitleVisible = false,
    this.itemArtist = "",
    this.itemLabelKey = StringKeys.empty,
    this.itemTitle = "",
    this.items = const [],
  });

  @override
  List<Object?> get props => [
        imageSource,
        imageSourceType,
        isArtistVisible,
        isScheduleLoaded,
        isTitleVisible,
        itemArtist,
        itemLabelKey,
        itemTitle,
        items,
      ];
}
