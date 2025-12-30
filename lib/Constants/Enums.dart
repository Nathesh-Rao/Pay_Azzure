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
