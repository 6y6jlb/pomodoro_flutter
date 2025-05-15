

import 'package:pomodoro_flutter/services/i_10n.dart';

enum PomodoroMode { standard, scheduleBased }

extension Label on PomodoroMode {
  String label() {
    return isScheduleBased() ? I10n().t.pomodoroModeLabel_schedule : I10n().t.pomodoroModeLabel_custom;
  }
}

extension TypeCheck on PomodoroMode {
  bool isScheduleBased() {
    return this == PomodoroMode.scheduleBased;
  }

  bool isStandart() {
    return !isScheduleBased();
  }
}
