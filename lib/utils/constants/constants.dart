// Asset Constants
const APP_BAR_LOGO_IMAGE = "assets/images/union_radio_logo_1.png";
const LOGO_IMAGE = "assets/images/union_radio_logo.png";

// Streams URLs
// TODO: временно. В релизе необходимо считывать этти данные в Firebase
const STREAM_LOW_URL = "http://78.155.222.238:8010/souz_radio_64.mp3";
const STREAM_MED_URL = "http://78.155.222.238:8010/souz_radio_128.mp3";
const STREAM_HIGH_URL = "http://78.155.222.238:8010/souz_radio_192.mp3";
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