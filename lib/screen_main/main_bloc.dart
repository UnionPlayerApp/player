import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:union_player_app/player/audio_player_handler.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AudioHandler _audioHandler;
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  MainBloc(this._audioHandler) : super(MainState()) {
    _customSubscription = _audioHandler.customEvent.listen((event) => _onCustom(event));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueue(queue));

    on<MainEvent>(_onMain);
  }

  FutureOr<void> _onMain(MainEvent event, Emitter<MainState> emitter) {
    log("MainBloc._onMain()", name: LOG_TAG);

    var isScheduleLoaded = false;
    var isTitleVisible = false;
    var isArtistVisible = false;
    var itemTitle = "";
    var itemArtist = "";
    var itemLabelKey = StringKeys.information_is_loading;
    var imageSourceType = ImageSourceType.assets;
    var imageSource = LOGO_IMAGE;

    if (event.isScheduleLoaded && event.mediaItems.isNotEmpty) {
      itemLabelKey = StringKeys.present_label;

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

    final newState = MainState(
        isScheduleLoaded: isScheduleLoaded,
        isTitleVisible: isTitleVisible,
        isArtistVisible: isArtistVisible,
        itemLabelKey: itemLabelKey,
        itemTitle: itemTitle,
        itemArtist: itemArtist,
        imageSourceType: imageSourceType,
        imageSource: imageSource);

    emitter(newState);
  }

  void _onCustom(error) {
    log("MainBloc._onCustom(error), error = $error", name: LOG_TAG);
    add(MainEvent(false, loadingError: error));
  }

  _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      log("MainBloc._onQueue(queue) -> queue is null", name: LOG_TAG);
      _onCustom("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      log("MainBloc._onQueue(queue) -> queue is empty", name: LOG_TAG);
      _onCustom("Schedule load error: queue is empty");
    } else {
      log("MainBloc._onQueue(queue) -> queue has ${queue.length} items", name: LOG_TAG);
      add(MainEvent(true, mediaItems: queue));
    }
  }

  @override
  Future<void> close() {
    log("MainBloc.close()", name: LOG_TAG);
    _customSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }
}
