enum AuthType { none, passwordOnly, otpOnly, both }

enum AttendanceState {
  notPunchedIn,
  punchedIn,
  punchedOut,
  leave,
  holiday,
  error
}

enum AttendancePendingAction { punchIn, punchOut, leave, none }

enum LogType { API_POST, API_GET, API_ERROR, INFO, NAVIGATION, REGULAR }
