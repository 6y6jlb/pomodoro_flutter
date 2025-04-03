import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';

class SettingsProvider with ChangeNotifier {
  late Box _box;
  late PomodoroSettings _settings;

  SettingsProvider() {
    _box = Hive.box('settings');
    _settings = _loadSettings();
  }

  PomodoroSettings get settings => _settings;

  void updateFromSchedule(Schedule newSchedule) {
    _settings = _settings.updateSchedule(newSchedule);
    _updateBoxDataAndNotifyListeners();
  }

  void updateUserBreaknDuration(int userBreakDuration) {
    _settings = _settings.updateUserBreaknDuration(userBreakDuration);
    _updateBoxDataAndNotifyListeners();
  }

  void updateUserSesstionDuration(int userSessionDuration) {
    _settings = _settings.updateUserSesstionDuration(userSessionDuration);
    _updateBoxDataAndNotifyListeners();
  }

  void updateSchedule(Schedule schedule) {
    _settings = _settings.updateSchedule(schedule);
    _updateBoxDataAndNotifyListeners();
  }

  void updateMode(PomodoroMode mode) {
    _settings = _settings.updateMode(mode);
    _updateBoxDataAndNotifyListeners();
  }

  void toggleMode() {
    _settings = _settings.updateMode(
      _settings.mode == PomodoroMode.standard
          ? PomodoroMode.scheduleBased
          : PomodoroMode.standard,
    );
    _updateBoxDataAndNotifyListeners();
  }

  PomodoroSettings _loadSettings() {
    if (_box.containsKey('pomodoro_settings')) {
      return _box.get('pomodoro_settings') as PomodoroSettings;
    }
    return PomodoroSettings(
      schedule: Schedule.initial(),
    );
  }

  void _updateBoxDataAndNotifyListeners() async {
    notifyListeners();
    await _box.put('pomodoro_settings', _settings);
  }
}
