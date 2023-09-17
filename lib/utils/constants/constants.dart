// Asset Constants
import 'package:flutter/material.dart';

const appBarLogoImage = "assets/images/union_radio_logo_outline.svg";
const logoImage = "assets/images/union_radio_logo.png";
const logoImage1 = "assets/images/union_radio_logo_1.png";

var icAudioQualityLow = "";
var icAudioQualityHigh = "";
var icAudioQualityMedium = "";
var icAudioQualityDefault = "";

const icAudioQualityLowBlack = "assets/images/audio_quality_low.png";
const icAudioQualityHighBlack = "assets/images/audio_quality_high.png";
const icAudioQualityMediumBlack = "assets/images/audio_quality_medium.png";
const icAudioQualityDefaultBlack = icAudioQualityMediumBlack;

const icAudioQualityLowWhite = "assets/images/audio_quality_low_white.png";
const icAudioQualityHighWhite = "assets/images/audio_quality_high_white.png";
const icAudioQualityMediumWhite = "assets/images/audio_quality_medium_white.png";
const icAudioQualityDefaultWhite = icAudioQualityMediumWhite;

const icListen = "assets/icons/ic_listen.svg";
const icSettings = "assets/icons/ic_settings.svg";
const icSchedule = "assets/icons/ic_schedule.svg";

void setIcAudioQuality(int themeId) {
  switch (themeId) {
    case themeLight:
      _setIcAudioQualityToBlack();
      break;
    case themeDark:
      _setIcAudioQualityToWhite();
      break;
    default:
      switch (WidgetsBinding.instance.platformDispatcher.platformBrightness) {
        case Brightness.light:
          _setIcAudioQualityToBlack();
          break;
        case Brightness.dark:
          _setIcAudioQualityToWhite();
          break;
      }
  }
}

void _setIcAudioQualityToWhite() {
  icAudioQualityLow = icAudioQualityLowWhite;
  icAudioQualityHigh = icAudioQualityHighWhite;
  icAudioQualityMedium = icAudioQualityMediumWhite;
  icAudioQualityDefault = icAudioQualityDefaultWhite;
}

void _setIcAudioQualityToBlack() {
  icAudioQualityLow = icAudioQualityLowBlack;
  icAudioQualityHigh = icAudioQualityHighBlack;
  icAudioQualityMedium = icAudioQualityMediumBlack;
  icAudioQualityDefault = icAudioQualityDefaultBlack;
}

//Streams IDs
const idStreamLow = 0;
const idStreamMedium = 1;
const idStreamHigh = 2;

// Периодичность проверки буффера плеера на заполненность. В сек.
const playerBufferCheckDuration = 3;
const playerBufferUncheckableDuration = 5;
const playerBufferHighCapacity = 15;
const playerBufferLowCapacity = 2;
const internetConnectionCheckDuration = 1;

// Logger
const logName = "UPA";
const emptyLogMessage = "Empty log message";

// FeedbackScreen
const phonePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
const maxMessageLength = 400;

// Периодичность проверки первого элемента расписания на завершение, сек
const scheduleCheckInterval = 5;

const audioNotificationChannelName = "Union Radio App Notification Channel";
const audioNotificationIcon = "mipmap/ic_notification_transparent"; //"mipmap/ic_notification";

const appInternationalTitle = "Union Radio 1";

const audioBackgroundTaskLogoAsset = "assets/images/union_radio_logo_1.png";

const audioQualityLow = 0;
const audioQualityMedium = 1;
const audioQualityHigh = 2;
const audioQualityUndefined = 3;

const themeSystem = 0;
const themeLight = 1;
const themeDark = 2;

const startPlayingStart = 0;
const startPlayingStop = 1;
const startPlayingLast = 2;

const langSystem = 0;
const langRU = 1;
const langBY = 2;
const langUS = 3;

const defaultAudioQualityId = audioQualityMedium;
const defaultThemeId = themeSystem;
const defaultStartPlayingId = startPlayingStop;
const defaultLangId = langSystem;
const defaultIsPlaying = false;

const keyAudioQuality = "AUDIO_QUALITY";
const keyTheme = "THEME";
const keyStartPlaying = "START_PLAYING";
const keyLang = "LANG";
const keyIsPlaying = "IS_PLAYING";
const keyAppTitle = "app_title";
const keyUrlStreamLow = "url_stream_low";
const keyUrlStreamMedium = "url_stream_medium";
const keyUrlStreamHigh = "url_stream_high";
const keyUrlSchedule = "url_schedule";

const newsArtAssetList = ["assets/images/news_01.png", "assets/images/news_02.png", "assets/images/news_03.png"];
const talkArtAssetList = ["assets/images/talk_01.png", "assets/images/talk_02.png", "assets/images/talk_03.png"];
const musicArtAssetList = ["assets/images/music_01.png", "assets/images/music_02.png", "assets/images/music_03.png"];
const imageFlagRU = "assets/images/Flag_of_Russia.png";
const imageFlagBY = "assets/images/Flag_of_Belarus.png";

// Custom action name for AudioHandler
const actionSetAudioQuality = "upa_action_set_audio_quality";
const actionStart = "upa_action_start";

// Google/Firebase Analytics event names
const gaAppStart = "UPA_APP_START";
const gaAppStop = "UPA_APP_STOP";
const gaPlayerStart = "UPA_PLAYER_START";
const gaPlayerStop = "UPA_PLAYER_STOP";
const gaAppStatus = "UPA_APP_STATUS";

const localeUS = Locale('en', 'US');
const localeRU = Locale('ru', 'RU');
const localeBY = Locale('be', 'BY');

const supportedLocales = [
  localeUS,
  localeRU,
  localeBY,
];
