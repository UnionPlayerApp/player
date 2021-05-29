import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/debug.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  MainBloc() : super(MainState()) {
    _customSubscription = AudioService.customEventStream.listen((error) => _onCustom(error));
    _queueSubscription = AudioService.queueStream.listen((queue) => _onQueue(queue));
  }

  void _onCustom(error) {
    log("MainBloc._onCustom(error), error = $error", name: LOG_TAG);
    add(MainEvent(false, loadingError: error));
  }

  _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      log("MainBloc._onQueue(queue), queue is null", name: LOG_TAG);
      _onCustom("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      log("MainBloc._onQueue(queue), queue is empty", name: LOG_TAG);
      _onCustom("Schedule load error: queue is empty");
    } else {
      log("MainBloc._onQueue(queue), queue has ${queue.length} elements", name: LOG_TAG);
      add(MainEvent(true, scheduleItems: queue));
    }
  }

  @override
  Future<void> close() {
    log("MainBloc.close()", name: LOG_TAG);
    _customSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    log("MainBloc.mapEventToState()", name: LOG_TAG);

    var isTitleVisible = false;
    var isArtistVisible = false;
    var itemTitle = "";
    var itemArtist = "";
    var itemLabelKey = StringKeys.information_is_loading;
    var imageSourceType = ImageSourceType.network;
    var imageSource = placeholderUrl();

    if (event.isScheduleLoaded && event.scheduleItems.isNotEmpty) {
      itemLabelKey = StringKeys.present_label;

      final item = event.scheduleItems[0];
      isTitleVisible = true;
      itemTitle = item.title;

       if (item.type.toScheduleItemType == ScheduleItemType.music) {
        isArtistVisible = true;
        itemArtist = item.artist!;
      }

      imageSource = randomUrl();
    }

    final state = MainState(
        isTitleVisible: isTitleVisible,
        isArtistVisible: isArtistVisible,
        itemLabelKey: itemLabelKey,
        itemTitle: itemTitle,
        itemArtist: itemArtist,
        imageSourceType: imageSourceType,
        imageSource: imageSource);

    yield state;
  }
}

extension _MediaItemExtension on MediaItem {

  int get type => this.extras!["type"];
}