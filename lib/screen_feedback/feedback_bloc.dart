import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:union_player_app/repository/feedback_repository/i_feedback_repository.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository _repository;
  final AppLogger _logger;

  FeedbackBloc(this._repository, this._logger) : super(AboutInfoLoadAwaitState()) {
    add(AboutInfoLoadEvent());
  }

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
  if (event is AboutInfoLoadEvent) {
    yield AboutInfoLoadAwaitState();
    yield await _getAboutInfoUrl();
  }
  if (event is HideBannerButtonPressedEvent){
    yield _getCurrentStateWithoutBanner();
  }
  if (event is WriteEmailButtonPressedEvent){
    // OPEN MAIL CLIENT
  }
  }

  Future<FeedbackState> _getAboutInfoUrl() async{
     return await _repository.getAboutPageUrl();
  }

  FeedbackState _getCurrentStateWithoutBanner(){
    _logger.logDebug("Current state has banner: ${this.state.hasBanner}");
    FeedbackState newState;
    if(this.state is AboutInfoLoadErrorState){
      newState = AboutInfoLoadErrorState((this.state as AboutInfoLoadErrorState).errorMessage);
    }
    if(this.state is AboutInfoLoadSuccessState){
      newState = AboutInfoLoadSuccessState((this.state as AboutInfoLoadSuccessState).url);
    }
    else {
      newState = AboutInfoLoadAwaitState();
    }
    newState.hasBanner = false;
    _logger.logDebug("New state has banner: ${newState.hasBanner} \n New state is ${newState.runtimeType}");
    return newState;
  }

}