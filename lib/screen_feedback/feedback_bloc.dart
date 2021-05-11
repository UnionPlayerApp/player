import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final AppLogger _logger;
  final SystemData _systemData;

  FeedbackBloc(this._logger, this._systemData)
      : super(AboutInfoLoadAwaitState()) {
    add(AboutInfoLoadEvent());
  }

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
    if (event is AboutInfoLoadEvent) {
      yield AboutInfoLoadAwaitState();
      yield await _getAboutInfoUrl();
    }
    if (event is HideBannerButtonPressedEvent) {
      yield _getCurrentStateWithoutBanner();
    }
    if (event is WriteEmailButtonPressedEvent) {
      // OPEN MAIL CLIENT
    }
  }

  Future<FeedbackState> _getAboutInfoUrl() async {
    return AboutInfoLoadSuccessState(_systemData.aboutData.urlEn);
  }

  FeedbackState _getCurrentStateWithoutBanner() {
    _logger.logDebug("Current state has banner: ${this.state.hasBanner}");
    FeedbackState newState;
    if (this.state is AboutInfoLoadErrorState) {
      newState = AboutInfoLoadErrorState(
          (this.state as AboutInfoLoadErrorState).errorMessage);
    }
    if (this.state is AboutInfoLoadSuccessState) {
      newState = AboutInfoLoadSuccessState(
          (this.state as AboutInfoLoadSuccessState).url);
    } else {
      newState = AboutInfoLoadAwaitState();
    }
    newState.hasBanner = false;
    _logger.logDebug(
        "New state has banner: ${newState.hasBanner} \n New state is ${newState.runtimeType}");
    return newState;
  }
}