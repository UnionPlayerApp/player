// Asset Constants
const APP_BAR_LOGO_IMAGE = "assets/images/union_radio_logo_outline.svg";
const LOGO_IMAGE = "assets/images/union_radio_logo.png";

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
const String PHONE_PATTERN =  r'(^(?:[+0]9)?[0-9]{10,12}$)';
const int MAX_MESSAGE_LENGTH = 400;

// Периодичность проверки первого элемента расписания на завершение, сек
const SCHEDULE_CHECK_INTERVAL = 5;

const AUDIO_NOTIFICATION_CHANNEL_NAME = "Union Radio App Notification Channel";
const AUDIO_NOTIFICATION_ICON = "drawable/ic_notification";

const APP_INTERNATIONAL_TITLE = "Union Radio 1";

const AUDIO_BACKGROUND_TASK_LOGO_ASSET = "assets/images/union_radio_logo_1.png";

const AUDIO_QUALITY_UNDEFINED = 0;
const AUDIO_QUALITY_LOW = 1;
const AUDIO_QUALITY_MEDIUM = 2;
const AUDIO_QUALITY_HIGH = 3;
