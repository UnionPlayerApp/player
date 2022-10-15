import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/player/app_player_handler.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

import 'main_item_view.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AudioHandler _audioHandler;
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;
  final _items = List<MainItemView>.empty(growable: true);

  MainBloc(this._audioHandler) : super(const MainState()) {
    _customSubscription = _audioHandler.customEvent.listen((event) => _onCustom(event));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueue(queue));

    on<MainEvent>(_onMain);
  }

  FutureOr<void> _onMain(MainEvent event, Emitter<MainState> emitter) {
    debugPrint("MainBloc._onMain()");

    var isScheduleLoaded = false;
    var isTitleVisible = false;
    var isArtistVisible = false;
    var itemTitle = "";
    var itemArtist = "";
    var itemLabelKey = StringKeys.informationIsLoading;
    var imageSourceType = ImageSourceType.assets;
    var imageSource = logoImage;

    if (event.isScheduleLoaded && event.mediaItems.isNotEmpty) {
      itemLabelKey = StringKeys.presLabel;

      final mediaItem = event.mediaItems[0];

      isScheduleLoaded = true;
      isTitleVisible = true;

      itemTitle = mediaItem.title;

      if (mediaItem.type.toScheduleItemType == ScheduleItemType.music) {
        isArtistVisible = true;
        itemArtist = mediaItem.artist!;
      }

      if (mediaItem.artUri != null) {
        imageSource = mediaItem.artUri!.path;
        imageSourceType = ImageSourceType.file;
      }
    }

    final newItems = List<MainItemView>.empty(growable: true);

    for (var mediaItem in event.mediaItems.reversed) {
      final mainItemView = MainItemView.fromMediaItem(mediaItem);
      if (_items.contains(mainItemView)) {
        break;
      } else {
        newItems.add(mainItemView);
      }
    }

    _items.addAll(newItems.reversed);

    final newState = MainState(
      imageSource: imageSource,
      imageSourceType: imageSourceType,
      isArtistVisible: isArtistVisible,
      isScheduleLoaded: isScheduleLoaded,
      isTitleVisible: isTitleVisible,
      itemArtist: itemArtist,
      itemLabelKey: itemLabelKey,
      itemTitle: itemTitle,
      items: _items,
    );

    emitter(newState);
  }

  void _onCustom(error) {
    debugPrint("MainBloc._onCustom(error), error = $error");
    add(MainEvent(false, loadingError: error));
  }

  _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      debugPrint("MainBloc._onQueue(queue) -> queue is null");
      _onCustom("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      debugPrint("MainBloc._onQueue(queue) -> queue is empty");
      _onCustom("Schedule load error: queue is empty");
    } else {
      debugPrint("MainBloc._onQueue(queue) -> queue has ${queue.length} items");
      add(MainEvent(true, mediaItems: queue));
    }
  }

  @override
  Future<void> close() {
    debugPrint("MainBloc.close()");
    _customSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }
}
