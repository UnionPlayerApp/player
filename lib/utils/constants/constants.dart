// Asset Constants
const APP_BAR_LOGO_IMAGE = "assets/images/union_radio_logo_outline.svg";
const LOGO_IMAGE = "assets/images/union_radio_logo.png";
const LOGO_IMAGE_1 = "assets/images/union_radio_logo_1.png";

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
const LOG_TAG = "UPA -> ";

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

const LANG_SYSTEM = 0;
const LANG_RU = 1;
const LANG_BE = 2;
const LANG_EN = 3;

const DEFAULT_AUDIO_QUALITY_ID = AUDIO_QUALITY_MEDIUM;
const DEFAULT_THEME_ID = THEME_SYSTEM;
const DEFAULT_START_PLAYING_ID = START_PLAYING_LAST;
const DEFAULT_LANG_ID = LANG_SYSTEM;

const NEWS_ART_ASSET_LIST = ["assets/images/news_01.png", "assets/images/news_02.png", "assets/images/news_03.png"];
const TALK_ART_ASSET_LIST = ["assets/images/talk_01.png", "assets/images/talk_02.png", "assets/images/talk_03.png"];
const MUSIC_ART_ASSET_LIST = ["assets/images/music_01.png", "assets/images/music_02.png", "assets/images/music_03.png"];
