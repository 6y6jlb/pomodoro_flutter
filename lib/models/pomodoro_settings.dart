import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';

class PomodoroSettings {
  final PomodoroMode mode;
  final Schedule? schedule;
  final int userSessionDurationInSeconds;
  final int userBreakDurationInSeconds;

  PomodoroSettings({
    this.mode = PomodoroMode.standard,
    this.schedule,
    this.userSessionDurationInSeconds =
        SettingsConstant.defaultSessionDurationInSeconds,
    this.userBreakDurationInSeconds =
        SettingsConstant.defaultBreakDurationInSeconds,
  });

  int get currentBreakDurationInSeconds {
    return mode == PomodoroMode.scheduleBased
        ? schedule?.breakDurationInSeconds ?? userBreakDurationInSeconds
        : userBreakDurationInSeconds;
  }

  int get currentSessionDurationInSeconds {
    return mode == PomodoroMode.scheduleBased
        ? schedule?.sessionDurationInSeconds ?? userSessionDurationInSeconds
        : userSessionDurationInSeconds;
  }

  bool get isActive {
    if (mode == PomodoroMode.scheduleBased) {
      return schedule?.isActiveNow() ?? false;
    }
    return true;
  }

  PomodoroSettings updateUserBreaknDuration(int userBreakDuration) {
    return _copyWith(userBreakDurationInSeconds: userBreakDuration);
  }

  PomodoroSettings updateUserSesstionDuration(int userSessionDuration) {
    return _copyWith(userSessionDurationInSeconds: userSessionDuration);
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
    int? userSessionDurationInSeconds,
    int? userBreakDurationInSeconds,
  }) {
    return PomodoroSettings(
      mode: mode ?? this.mode,
      schedule: schedule ?? this.schedule,
      userSessionDurationInSeconds:
          userSessionDurationInSeconds ?? this.userSessionDurationInSeconds,
      userBreakDurationInSeconds:
          userBreakDurationInSeconds ?? this.userBreakDurationInSeconds,
    );
  }
}
