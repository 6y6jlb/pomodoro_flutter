

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';

class SettingsProvider with ChangeNotifier {
  late PomodoroSettings _settings;

  SettingsProvider(schedule) {
    _settings = PomodoroSettings(
      schedule: schedule
    );
  }

  PomodoroSettings get settings => _settings;

    void updateFromSchedule(Schedule newSchedule) {
    _settings = _settings.updateSchedule(newSchedule);
    notifyListeners();
  }

    void updateUserBreaknDuration(int userBreakDuration) {
    _settings = _settings.updateUserBreaknDuration(userBreakDuration);
    notifyListeners();
  }

  void updateUserSesstionDuration(int userSessionDuration) {
    _settings = _settings.updateUserSesstionDuration(userSessionDuration);
    notifyListeners();
  }


  void updateSchedule(Schedule schedule) {
    _settings = _settings.updateSchedule(schedule);
    notifyListeners();
  }

  void updateMode(PomodoroMode mode) {
    _settings = _settings.updateMode(mode);
    notifyListeners();
  }

    void toggleMode() {
    _settings = _settings.updateMode(_settings.mode == PomodoroMode.standard ? PomodoroMode.scheduleBased : PomodoroMode.standard);
    notifyListeners();
  }
}