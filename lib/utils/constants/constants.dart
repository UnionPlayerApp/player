// Asset Constants
import 'dart:ui';

const APP_BAR_LOGO_IMAGE = "assets/images/union_radio_logo_outline.svg";
const LOGO_IMAGE = "assets/images/union_radio_logo.png";
const LOGO_IMAGE_1 = "assets/images/union_radio_logo_1.png";

const IC_AUDIO_QUALITY_LOW = "assets/images/audio_quality_low.png";
const IC_AUDIO_QUALITY_HIGH = "assets/images/audio_quality_high.png";
const IC_AUDIO_QUALITY_MEDIUM = "assets/images/audio_quality_medium.png";

const IC_AUDIO_QUALITY_LOW_WHITE = "assets/images/audio_quality_low_white.png";
const IC_AUDIO_QUALITY_HIGH_WHITE = "assets/images/audio_quality_high_white.png";
const IC_AUDIO_QUALITY_MEDIUM_WHITE = "assets/images/audio_quality_medium_white.png";

const IC_AUDIO_QUALITY_DEFAULT = IC_AUDIO_QUALITY_MEDIUM;
const IC_AUDIO_QUALITY_DEFAULT_WHITE = IC_AUDIO_QUALITY_MEDIUM_WHITE;

//Streams IDs
const ID_STREAM_LOW = 0;
const ID_STREAM_MEDIUM = 1;
const ID_STREAM_HIGH = 2;

// Периодичность проверки буффера плеера на заполненность. В сек.
const PLAYER_BUFFER_CHECK_DURATION = 3;
const PLAYER_BUFFER_UNCHECKABLE_DURATION = 5;
const PLAYER_BUFFER_HIGH_CAPACITY = 15;
const PLAYER_BUFFER_LOW_CAPACITY = 2;
const INTERNET_CONNECTION_CHECK_DURATION = 1;

// Logger
const logName = "UPA";
const emptyLogMessage = "Empty log message";

// FeedbackScreen
const String PHONE_PATTERN = r'(^(?:[+0]9)?[0-9]{10,12}$)';
const int MAX_MESSAGE_LENGTH = 400;

// Периодичность проверки первого элемента расписания на завершение, сек
const SCHEDULE_CHECK_INTERVAL = 5;

const AUDIO_NOTIFICATION_CHANNEL_NAME = "Union Radio App Notification Channel";
const AUDIO_NOTIFICATION_ICON = "mipmap/ic_notification_transparent"; //"mipmap/ic_notification";

const APP_INTERNATIONAL_TITLE = "Union Radio 1";

const AUDIO_BACKGROUND_TASK_LOGO_ASSET = "assets/images/union_radio_logo_1.png";

const AUDIO_QUALITY_LOW = 0;
const AUDIO_QUALITY_MEDIUM = 1;
const AUDIO_QUALITY_HIGH = 2;
const AUDIO_QUALITY_UNDEFINED = 3;

const THEME_SYSTEM = 0;
const THEME_LIGHT = 1;
const THEME_DARK = 2;

const START_PLAYING_START = 0;
const START_PLAYING_STOP = 1;
const START_PLAYING_LAST = 2;

const langSystem = 0;
const langRU = 1;
const langBY = 2;
const langUS = 3;

const DEFAULT_AUDIO_QUALITY_ID = AUDIO_QUALITY_MEDIUM;
const DEFAULT_THEME_ID = THEME_SYSTEM;
const DEFAULT_START_PLAYING_ID = START_PLAYING_STOP;
const DEFAULT_LANG_ID = langSystem;
const DEFAULT_IS_PLAYING = false;

const KEY_AUDIO_QUALITY = "AUDIO_QUALITY";
const KEY_THEME = "THEME";
const KEY_START_PLAYING = "START_PLAYING";
const KEY_LANG = "LANG";
const KEY_IS_PLAYING = "IS_PLAYING";
const KEY_APP_TITLE = "app_title";
const KEY_URL_STREAM_LOW = "url_stream_low";
const KEY_URL_STREAM_MEDIUM = "url_stream_medium";
const KEY_URL_STREAM_HIGH = "url_stream_high";
const KEY_URL_SCHEDULE = "url_schedule";

const NEWS_ART_ASSET_LIST = ["assets/images/news_01.png", "assets/images/news_02.png", "assets/images/news_03.png"];
const TALK_ART_ASSET_LIST = ["assets/images/talk_01.png", "assets/images/talk_02.png", "assets/images/talk_03.png"];
const MUSIC_ART_ASSET_LIST = ["assets/images/music_01.png", "assets/images/music_02.png", "assets/images/music_03.png"];

// Custom action name for AudioHandler
const ACTION_SET_AUDIO_QUALITY = "upa_action_set_audio_quality";
const ACTION_START = "upa_action_start";

// Google/Firebase Analytics event names
const GA_APP_START = "UPA_APP_START";
const GA_APP_STOP = "UPA_APP_STOP";
const GA_PLAYER_START = "UPA_PLAYER_START";
const GA_PLAYER_STOP = "UPA_PLAYER_STOP";
const GA_APP_STATUS = "UPA_APP_STATUS";

const localeUS = Locale('en', 'US');
const localeRU = Locale('ru', 'RU');
const localeBY = Locale('be', 'BY');

const supportedLocales = [
  localeUS,
  localeRU,
  localeBY,
];
