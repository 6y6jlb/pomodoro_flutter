import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';

part 'pomodoro_settings.g.dart';

@HiveType(typeId: 2)
class PomodoroSettings {
  @HiveField(0)
  final PomodoroMode mode;

  @HiveField(1)
  final Schedule schedule;

  @HiveField(2)
  final int userSessionDurationInSeconds;

  @HiveField(3)
  final int userBreakDurationInSeconds;

  PomodoroSettings({
    this.mode = PomodoroMode.standard,
    Schedule? schedule,
    this.userSessionDurationInSeconds =
        SettingsConstant.defaultSessionDurationInSeconds,
    this.userBreakDurationInSeconds =
        SettingsConstant.defaultBreakDurationInSeconds,
  }) : schedule = schedule ?? Schedule.initial();

  int get currentBreakDurationInSeconds {
    return mode == PomodoroMode.scheduleBased
        ? schedule.breakDurationInSeconds
        : userBreakDurationInSeconds;
  }

  int get currentSessionDurationInSeconds {
    return mode == PomodoroMode.scheduleBased
        ? schedule.sessionDurationInSeconds
        : userSessionDurationInSeconds;
  }

  int get currentBreakDurationInMinutes => currentBreakDurationInSeconds ~/ 60;

  int get currentSessionDurationInMinutes => currentSessionDurationInSeconds ~/ 60;

  bool get isActive {
    if (mode == PomodoroMode.scheduleBased) {
      return schedule.isActiveNow();
    }
    return true;
  }

  PomodoroSettings updateUserBreaknDuration(int userBreakDuration) {
    return copyWith(userBreakDurationInSeconds: userBreakDuration);
  }

  PomodoroSettings updateUserSesstionDuration(int userSessionDuration) {
    return copyWith(userSessionDurationInSeconds: userSessionDuration);
  }

  PomodoroSettings updateSchedule(Schedule? schedule) {
    return copyWith(schedule: schedule);
  }

  PomodoroSettings updateMode(PomodoroMode mode) {
    return copyWith(mode: mode);
  }

  PomodoroSettings copyWith({
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
