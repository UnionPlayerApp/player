import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screen_listen/listen_event.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (event is! ListenPlaybackEvent) {
      log("*** AppBlocObserver -> onEvent()");
      log("bloc  = $bloc");
      log("event = $event");
    }
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("*** AppBlocObserver -> onChange()");
    log("bloc          = $bloc");
    log("state current = ${change.currentState}");
    log("state next    = ${change.nextState}");
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    log("*** AppBlocObserver -> onCreate()");
    log("bloc = $bloc");
    super.onCreate(bloc);
  }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   log("*** AppBlocObserver -> onTransition()");
  //   log("bloc       = $bloc");
  //   log("transition = $transition");
  //   super.onTransition(bloc, transition);
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log("*** AppBlocObserver -> onError()");
    log("bloc  = $bloc");
    log("error = $error");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log("*** AppBlocObserver -> onClose()");
    log("bloc = $bloc");
    super.onClose(bloc);
  }
}