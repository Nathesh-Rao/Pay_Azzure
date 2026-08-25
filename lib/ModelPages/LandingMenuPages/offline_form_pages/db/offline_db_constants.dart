import 'package:axpertflutter/Constants/AppStorage.dart';

class OfflineDBConstants {
  OfflineDBConstants._();

  static String OFFLINE_PAGES_URL() {
    return "https://raw.githubusercontent.com/amrith4agile/offline_sample_pages/refs/heads/main/offline_pages.json";

    String userEnteredUrl = AppStorage().retrieveValue(AppStorage.PROJECT_URL);
    if (!userEnteredUrl.startsWith('http')) {
      userEnteredUrl = 'https://$userEnteredUrl';
    }
    Uri uri = Uri.parse(userEnteredUrl);

    String baseUrl = "${uri.scheme}://${uri.host}";

    return "$baseUrl/MobileOfflineStruct/offline_pages.json";
  }

  static String OFFLINE_CONFIG_URL() {
    String userEnteredUrl = AppStorage().retrieveValue(AppStorage.PROJECT_URL);
    if (!userEnteredUrl.startsWith('http')) {
      userEnteredUrl = 'https://$userEnteredUrl';
    }
    Uri uri = Uri.parse(userEnteredUrl);

    String baseUrl = "${uri.scheme}://${uri.host}";

    return "$baseUrl/MobileOfflineStruct/offline_config.json";
  }

  static String VERSION_INFO_URL() {
    String userEnteredUrl = AppStorage().retrieveValue(AppStorage.PROJECT_URL);
    if (!userEnteredUrl.startsWith('http')) {
      userEnteredUrl = 'https://$userEnteredUrl';
    }
    Uri uri = Uri.parse(userEnteredUrl);

    String baseUrl = "${uri.scheme}://${uri.host}";

    return "$baseUrl/MobileOfflineStruct/appVersionInfo.json";
  }

  static const String CREATE_QUERY = 'CREATE TABLE IF NOT EXISTS ';

  static const int RECORD_STATUS_PENDING = 0;
  static const int RECORD_STATUS_SUCCESS = 1;
  static const int RECORD_STATUS_ERROR = 2;
  static const int RECORD_STATUS_QUEUED = 3;

  static const int QUEUE_STATUS_PENDING = 0;
  static const int QUEUE_STATUS_SUCCESS = 1;
  static const int QUEUE_STATUS_ERROR = 2;
  static const int QUEUE_STATUS_PARTIAL = 3;

  // static const int STATUS_FORCE_PUSHED = 3;
  // ================= TABLE NAMES =================

  static const String TABLE_OFFLINE_PAGES = 'offline_pages';
  static const String TABLE_DATASOURCES = 'offline_datasources';
  static const String TABLE_DATASOURCE_DATA = 'offline_datasource_data';
  static const String TABLE_PENDING_REQUESTS = 'offline_pending_requests';
  static const String TABLE_OFFLINE_USER = 'offline_user';
  static const String TABLE_AUDIT_LOGS = 'ax_audit_logs';
  static const String TABLE_CACHED_SAVE_QUEUE = 'cached_save_queue';

  // ================= COMMON COLUMNS =================

  static const String COL_ID = 'id';
  static const String COL_CREATED_AT = 'created_at';
  static const String COL_USERNAME = 'username';
  static const String COL_PROJECT_NAME = 'project_name';
  static const String COL_TRANS_ID = 'trans_id';
  static const String COL_IS_SYNCED = 'is_synced';
  static const String COL_LAST_SYNCED = 'last_synced';
  // ================= OFFLINE PAGES =================

  static const String COL_PAGE_JSON = 'page_json';
  static const String COL_FETCHED_AT = 'fetched_at';

  // ================= DATASOURCES =================

  static const String COL_DATASOURCE_NAMES = 'datasource_names';

  // ================= DATASOURCE DATA =================

  static const String COL_DATASOURCE_NAME = 'datasource_name';
  static const String COL_RESPONSE_JSON = 'response_json';

  // ================= PENDING REQUESTS =================

  static const String COL_REQUEST_JSON = 'request_json';
  static const String COL_STATUS = 'status';
  // static const String COL_RESPONSE = 'response';

  // ================= Audit TABLE =================
  static const String COL_ACTION = 'action';
  static const String COL_IS_ERROR = 'is_error';
  static const String COL_RESPONSE = 'response';
  static const String COL_REMARKS = 'remarks';
  static const String COL_DEVICE_INFO = 'device_info';

  // ================= USER TABLE =================

  static const String COL_DISPLAY_NAME = 'display_name';
  static const String COL_SESSION_ID = 'session_id';
  static const String COL_RAW_JSON = 'raw_json';
  static const String COL_LAST_LOGIN_AT = 'last_login_at';
  static const String COL_PASSWORD_HASH = 'password_hash';

// ================= QUEUE TABLE NAME =================

// ================= QUEUE TABLE COLUMNS =================
  static const String COL_QUEUE_ID = 'queue_id';
  static const String COL_AXM_RECIDS = 'axm_recids';
  static const String COL_PAYLOADS_COUNT = 'payloads_count';
  static const String COL_STATUS_TEXT = 'status_text';
  static const String COL_UPDATED_AT = 'updated_at';
  static const String COL_QUEUE_RESPONSE =
      'queue_response'; // server reply at push time
  static const String COL_FCM_RESPONSE =
      'fcm_response'; // FCM payload at confirm time
  static const String COL_SOURCE_TABLE = 'source_table';

// ================= MIGRATIONS =================
  static const String ALTER_PENDING_REQUESTS_ADD_RESPONSE =
      'ALTER TABLE $TABLE_PENDING_REQUESTS ADD COLUMN $COL_RESPONSE TEXT';

  static const String ALTER_CACHED_SAVE_QUEUE_ADD_SOURCE_TABLE =
      'ALTER TABLE $TABLE_CACHED_SAVE_QUEUE ADD COLUMN $COL_SOURCE_TABLE TEXT NOT NULL DEFAULT \'$TABLE_PENDING_REQUESTS\'';

  static const String ALTER_AUDIT_LOGS_ADD_STATUS =
      'ALTER TABLE $TABLE_AUDIT_LOGS ADD COLUMN $COL_STATUS INTEGER NOT NULL DEFAULT $RECORD_STATUS_PENDING';
  // ================= CREATE TABLE QUERIES =================
  // -------- OFFLINE PAGES --------
  static final String CREATE_OFFLINE_PAGES_TABLE = CREATE_QUERY +
      TABLE_OFFLINE_PAGES +
      '''
      (
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COL_USERNAME TEXT,
        $COL_PROJECT_NAME TEXT,
        $COL_TRANS_ID TEXT,
        $COL_PAGE_JSON TEXT,
        $COL_FETCHED_AT TEXT
      );
    ''';

  // -------- DATASOURCE NAMES (PER USER+PROJECT) --------
  static final String CREATE_DATASOURCES_TABLE = CREATE_QUERY +
      TABLE_DATASOURCES +
      '''
      (
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COL_USERNAME TEXT,
        $COL_PROJECT_NAME TEXT,
        $COL_TRANS_ID TEXT,
        $COL_DATASOURCE_NAMES TEXT
      );
    ''';

  // -------- DATASOURCE DATA (PER USER+PROJECT+FORM) --------
  static final String CREATE_DATASOURCE_DATA_TABLE = CREATE_QUERY +
      TABLE_DATASOURCE_DATA +
      '''
      (
        $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COL_USERNAME TEXT,
        $COL_PROJECT_NAME TEXT,
        $COL_TRANS_ID TEXT,
        $COL_DATASOURCE_NAME TEXT,
        $COL_RESPONSE_JSON TEXT
      );
    ''';

  // -------- PENDING REQUESTS --------
  static final String CREATE_PENDING_REQUESTS_TABLE = CREATE_QUERY +
      TABLE_PENDING_REQUESTS +
      '''
    (
      $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COL_USERNAME TEXT,
      $COL_PROJECT_NAME TEXT,
      $COL_REQUEST_JSON TEXT UNIQUE,
      $COL_STATUS INTEGER,
      $COL_RESPONSE TEXT,
      $COL_CREATED_AT TEXT
    );
  ''';
  // -------- OFFLINE USER --------
  // static final String CREATE_OFFLINE_USER_TABLE = CREATE_QUERY +
  //     TABLE_OFFLINE_USER +
  //     '''
  //   (
  //     $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
  //     $COL_PROJECT_NAME TEXT,
  //     $COL_USERNAME TEXT,
  //     $COL_PASSWORD_HASH TEXT,
  //     $COL_DISPLAY_NAME TEXT,
  //     $COL_SESSION_ID TEXT,
  //     $COL_RAW_JSON TEXT,
  //     $COL_LAST_LOGIN_AT TEXT
  //   );
  // ''';

  // -------- AUDIT LOGS --------
  // static final String CREATE_AUDIT_LOGS_TABLE = CREATE_QUERY +
  //     TABLE_AUDIT_LOGS +
  //     '''
  //   (
  //     $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
  //     $COL_USERNAME TEXT,
  //     $COL_PROJECT_NAME TEXT,
  //     $COL_ACTION TEXT,
  //     $COL_CREATED_AT TEXT,
  //     $COL_IS_ERROR INTEGER,
  //     $COL_RESPONSE TEXT,
  //     $COL_REMARKS TEXT,
  //     $COL_DEVICE_INFO TEXT
  //   );
  // ''';

  static const String CREATE_OFFLINE_USER_TABLE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_OFFLINE_USER (
    $COL_ID               INTEGER PRIMARY KEY AUTOINCREMENT,
    $COL_PROJECT_NAME     TEXT NOT NULL,
    $COL_USERNAME         TEXT NOT NULL,
    $COL_PASSWORD_HASH    TEXT NOT NULL,
    $COL_DISPLAY_NAME     TEXT,
    $COL_SESSION_ID       TEXT,
    $COL_RAW_JSON         TEXT,
    $COL_LAST_LOGIN_AT    TEXT,
    $COL_LAST_SYNCED      TEXT,
    UNIQUE($COL_PROJECT_NAME, $COL_USERNAME)
  )
''';

  static const String CREATE_AUDIT_LOGS_TABLE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_AUDIT_LOGS (
    $COL_ID           INTEGER PRIMARY KEY AUTOINCREMENT,
    $COL_USERNAME     TEXT    NOT NULL DEFAULT '',
    $COL_PROJECT_NAME TEXT    NOT NULL DEFAULT '',
    $COL_ACTION       TEXT    NOT NULL,
    $COL_CREATED_AT   TEXT    NOT NULL,
    $COL_IS_ERROR     INTEGER NOT NULL DEFAULT 0,
    $COL_RESPONSE     TEXT             DEFAULT '',
    $COL_REMARKS      TEXT             DEFAULT '',
    $COL_IS_SYNCED    INTEGER NOT NULL DEFAULT 0,
    $COL_STATUS       INTEGER NOT NULL DEFAULT $RECORD_STATUS_PENDING
  )
''';

// ================= CREATE QUEUE TABLE =================
//   static const String CREATE_CACHED_SAVE_QUEUE_TABLE = '''
//   CREATE TABLE IF NOT EXISTS $TABLE_CACHED_SAVE_QUEUE (
//     $COL_ID           INTEGER PRIMARY KEY AUTOINCREMENT,
//     $COL_QUEUE_ID     TEXT    NOT NULL UNIQUE,
//     $COL_USERNAME     TEXT    NOT NULL,
//     $COL_PROJECT_NAME TEXT    NOT NULL,
//     $COL_AXM_RECIDS   TEXT    NOT NULL DEFAULT '[]',
//     $COL_PAYLOADS_COUNT INTEGER NOT NULL DEFAULT 0,
//     $COL_STATUS       INTEGER NOT NULL DEFAULT 0,
//     $COL_CREATED_AT   TEXT    NOT NULL,
//     $COL_UPDATED_AT   TEXT    NOT NULL
//   )
// ''';

  static const String CREATE_CACHED_SAVE_QUEUE_TABLE = '''
  CREATE TABLE IF NOT EXISTS $TABLE_CACHED_SAVE_QUEUE (
    $COL_ID              INTEGER PRIMARY KEY AUTOINCREMENT,
    $COL_QUEUE_ID        TEXT    NOT NULL UNIQUE,
    $COL_SOURCE_TABLE    TEXT    NOT NULL DEFAULT '$TABLE_PENDING_REQUESTS',
    $COL_USERNAME        TEXT    NOT NULL,
    $COL_PROJECT_NAME    TEXT    NOT NULL,
    $COL_AXM_RECIDS      TEXT    NOT NULL DEFAULT '[]',
    $COL_PAYLOADS_COUNT  INTEGER NOT NULL DEFAULT 0,
    $COL_STATUS          INTEGER NOT NULL DEFAULT 0,
    $COL_QUEUE_RESPONSE  TEXT             DEFAULT '',
    $COL_FCM_RESPONSE    TEXT             DEFAULT '',
    $COL_CREATED_AT      TEXT    NOT NULL,
    $COL_UPDATED_AT      TEXT    NOT NULL
  )
''';
}
