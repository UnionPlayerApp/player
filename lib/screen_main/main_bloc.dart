import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/debug.dart';
import 'package:union_player_app/utils/core/image_source_type.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  late final StreamSubscription _subscription;

  final IScheduleRepository _repository;

  MainBloc(this._repository) : super(MainState()) {
    _subscription = _repository.stream().listen((state) {
      log("MainBloc => repository state changed", name: LOG_TAG);
      if (state is ScheduleRepositoryLoadSuccessState) {
        log("MainBloc => repository state changed => state is SUCCESS",
            name: LOG_TAG);
        add(MainEvent(true, scheduleItems: state.items));
      }
      if (state is ScheduleRepositoryLoadErrorState) {
        log("MainBloc => repository state changed => state is ERROR",
            name: LOG_TAG);
        add(MainEvent(false));
      }
    });
  }

  @override
  Future<void> close() {
    log("MainBloc => close()", name: LOG_TAG);
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    bool isTitleVisible = false;
    bool isArtistVisible = false;
    String itemTitle = "";
    String itemArtist = "";
    StringKeys itemLabelKey = StringKeys.information_not_loaded;

    final imageSourceType = ImageSourceType.network;
    final imageSource = randomUrl();

    if (event.isScheduleLoaded && event.scheduleItems.isNotEmpty) {
      itemLabelKey = StringKeys.present_label;

      final item = event.scheduleItems[0];
      isTitleVisible = true;
      itemTitle = item.title;

      if (item.type == ScheduleItemType.music) {
        isArtistVisible = true;
        itemArtist = item.artist;
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
