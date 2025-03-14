import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';

class PomodoroSettings {
  final PomodoroMode mode;
  final Schedule? schedule;
  final int userSessionDuration;
  final int userBreakDuration;

  int get currentBreakDuration {
    return mode == PomodoroMode.scheduleBased
        ? schedule?.breakDuration ?? userBreakDuration
        : userBreakDuration;
  }

  int get currentSessionDuration {
    return mode == PomodoroMode.scheduleBased
        ? schedule?.sessionDuration ?? userSessionDuration
        : userSessionDuration;
  }

  bool get isActive {
    if (mode == PomodoroMode.scheduleBased) {
      return schedule?.isActiveNow() ?? false;
    }
    return true;
  }

  PomodoroSettings({
    this.mode = PomodoroMode.standard,
    this.schedule,
    this.userSessionDuration = SettingsConstant.defaultSessionDuration,
    this.userBreakDuration = SettingsConstant.defaultBreakDuration,
  });

  PomodoroSettings updateUserBreaknDuration(int userBreakDuration) {
    return _copyWith(userBreakDuration: userBreakDuration);
  }

  PomodoroSettings updateUserSesstionDuration(int userSessionDuration) {
    return _copyWith(userSessionDuration: userSessionDuration);
  }

  PomodoroSettings updateSchedule(Schedule schedule) {
    return _copyWith(schedule: schedule);
  }

  PomodoroSettings updateMode(PomodoroMode mode) {
    return _copyWith(mode: mode);
  }

  PomodoroSettings _copyWith({
    PomodoroMode? mode,
    Schedule? schedule,
    int? userSessionDuration,
    int? userBreakDuration,
  }) {
    return PomodoroSettings(
      mode: mode ?? this.mode,
      schedule: schedule ?? this.schedule,
      userSessionDuration: userSessionDuration ?? this.userSessionDuration,
      userBreakDuration: userBreakDuration ?? this.userBreakDuration,
    );
  }
}
