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
    log("MainBloc => repository state changed => state is ERROR", name: LOG_TAG);
    add(MainEvent(false, loadingError: error));
  }

  _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      log("MainBloc._onQueue => Queue load ERROR (queue == null))", name: LOG_TAG);
      _onCustom("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      log("MainBloc._onQueue => Queue load ERROR (queue is empty))", name: LOG_TAG);
      _onCustom("Schedule load error: queue is empty");
    } else {
      log("MainBloc._onQueue => Queue load SUCCESS ${queue.length} items", name: LOG_TAG);
      add(MainEvent(true, scheduleItems: queue));
    }
  }

  @override
  Future<void> close() {
    log("MainBloc => close()", name: LOG_TAG);
    _customSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    bool isTitleVisible = false;
    bool isArtistVisible = false;
    String itemTitle = "";
    String itemArtist = "";
    StringKeys itemLabelKey = StringKeys.information_is_loading;

    final imageSourceType = ImageSourceType.network;
    final imageSource = randomUrl();

    if (event.isScheduleLoaded && event.scheduleItems.isNotEmpty) {
      itemLabelKey = StringKeys.present_label;

      final item = event.scheduleItems[0];
      isTitleVisible = true;
      itemTitle = item.title;

      if (item.type == ScheduleItemType.music) {
        isArtistVisible = true;
        itemArtist = item.artist!;
      }
    }

    final state = MainState(
        isTitleVisible: isTitleVisible,
        isArtistVisible: isArtistVisible,
        itemLabelKey: itemLabelKey,
        itemTitle: itemTitle,
        itemArtist: itemArtist,
        imageSourceType: imageSourceType,
        imageSource: imageSource);

    log("MainBloc => mapEventToState => state = $state", name: LOG_TAG);

    yield state;
  }
}

extension _MediaItemExtension on MediaItem {

  ScheduleItemType get type => this.extras!["type"];
}