import 'package:pomodoro_flutter/utils/translation/t.dart';

enum PomodoroMode { standard, scheduleBased }

extension Label on PomodoroMode {
  String label() {
    return isScheduleBased() ? t.pomoodoroModeLabel_schedule : t.pomodoroModeLabel_custom;
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
