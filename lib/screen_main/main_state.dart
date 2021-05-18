import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainState extends Equatable {
  final StringKeys itemLabelKey;
  final bool isTitleVisible;
  final bool isArtistVisible;
  final String itemTitle;
  final String itemArtist;
  final ImageSourceType imageSourceType;
  final String imageSource;

  const MainState(
      {this.itemLabelKey = StringKeys.empty,
      this.isTitleVisible = false,
      this.isArtistVisible = false,
      this.itemTitle = "",
      this.itemArtist = "",
      this.imageSourceType = ImageSourceType.none,
      this.imageSource = ""});

  @override
  List<Object?> get props => [
        itemLabelKey,
        isTitleVisible,
        isArtistVisible,
        itemTitle,
        itemArtist,
        imageSourceType,
        imageSource
      ];
}
