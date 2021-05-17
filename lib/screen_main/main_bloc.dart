import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  late final StreamSubscription _subscription;

  final BuildContext _context;
  final IScheduleRepository _repository;

  MainBloc(this._context, this._repository) : super(MainState()) {
    _subscription = _repository.stream().listen((state) {
      if (state is ScheduleRepositoryLoadSuccessState) {
        add(MainEvent(true, scheduleItems: state.items));
      }
      if (state is ScheduleRepositoryLoadErrorState) {
        add(MainEvent(false));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    bool isArtistVisible = false;
    String itemTitle = "";
    String itemArtist = "";
    final itemLabel = translate(StringKeys.present_label, _context);

    if (event.isScheduleLoaded) {
      if (event.scheduleItems.isEmpty) {
        itemTitle = translate(StringKeys.information_not_loaded, _context);
      } else {
        final item = event.scheduleItems[0];
        itemTitle = item.title;
        if (item.type == ScheduleItemType.music) {
          isArtistVisible = true;
          itemArtist = item.artist;
        }
      }
    } else {
      itemTitle = translate(StringKeys.information_not_loaded, _context);
    }

    yield MainState(
        isArtistVisible: isArtistVisible,
        itemLabel: itemLabel,
        itemTitle: itemTitle,
        itemArtist: itemArtist);
  }
}
