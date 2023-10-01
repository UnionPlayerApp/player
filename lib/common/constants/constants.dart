// Asset Constants
import 'package:flutter/material.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/start_playing_type.dart';

const appBarLogoImage = "assets/images/union_radio_logo_outline.svg";
const logoImage = "assets/images/union_radio_logo.png";
const logoImage1 = "assets/images/union_radio_logo_1.png";

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

const startPlayingStart = 0;
const startPlayingStop = 1;
const startPlayingLast = 2;

const defaultSoundQualityType = SoundQualityType.medium;
const defaultThemeMode = ThemeMode.system;
const defaultStartPlayingType = StartPlayingType.last;
const defaultLanguageType = LanguageType.system;
const defaultIsPlaying = false;

const keySoundQuality = "SOUND_QUALITY";
const keyTheme = "THEME";
const keyStartPlaying = "START_PLAYING";
const keyLanguage = "LANG";
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
const actionSetSoundQuality = "upa_action_set_audio_quality";
const actionStart = "upa_action_start";

// Google/Firebase Analytics event names
const gaAppStart = "UPA_APP_START";
const gaAppStop = "UPA_APP_STOP";
const gaPlayerStart = "UPA_PLAYER_START";
const gaPlayerStop = "UPA_PLAYER_STOP";
const gaAppStatus = "UPA_APP_STATUS";

const languageEN = 'en';
const languageRU = 'ru';
const languageBE = 'be';

const localeUS = Locale(languageEN, 'US');
const localeRU = Locale(languageRU, 'RU');
const localeBY = Locale(languageBE, 'BY');

const supportedLocales = [
  localeUS,
  localeRU,
  localeBY,
];

class AppIcons {
  static const icArrowBack = "assets/icons/ic_arrow_back.svg";
  static const icArrowForward = "assets/icons/ic_arrow_forward.svg";
  static const icAudioQuality = "assets/icons/ic_audio_quality.svg";
  static const icListen = "assets/icons/ic_listen.svg";
  static const icPause = "assets/icons/ic_pause.svg";
  static const icPlay = "assets/icons/ic_play.svg";
  static const icSchedule = "assets/icons/ic_schedule.svg";
  static const icSettings = "assets/icons/ic_settings.svg";
  static const icEmail = "assets/icons/ic_email.svg";
  static const icTelegram = "assets/icons/ic_telegram.svg";
  static const icWhatsapp = "assets/icons/ic_whatsapp.svg";
}

class AppImages {
  static const imDisk0 = "assets/images/disk_0.png";
  static const imDisk1 = "assets/images/disk_1.png";
  static const imDisk2 = "assets/images/disk_2.png";
  static const imCircle150Blur8 = "assets/images/circle_150_blur_8.png";
  static const imRadioLogo = "assets/images/union_radio_logo.png";
}
