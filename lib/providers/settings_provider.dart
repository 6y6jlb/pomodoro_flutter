import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';

class SettingsProvider with ChangeNotifier {
  late Box _box;
  late PomodoroSettings _settings;

  SettingsProvider() {
    _box = Hive.box('settings');
    _settings = _loadSettings();
  }

  PomodoroSettings get settings => _settings;

  void updateUserBreaknDuration(int userBreakDuration) {
    _settings = _settings.updateUserBreaknDuration(userBreakDuration);
    _updateBoxDataAndNotifyListeners();
  }

  void updateUserSesstionDuration(int userSessionDuration) {
    _settings = _settings.updateUserSesstionDuration(userSessionDuration);
    _updateBoxDataAndNotifyListeners();
  }

  void updateSchedule(Schedule? schedule) {
    _settings = _settings.updateSchedule(schedule);
    _updateBoxDataAndNotifyListeners();
  }

  void updateMode(PomodoroMode mode) {
    _settings = _settings.updateMode(mode);
    _updateBoxDataAndNotifyListeners();
    _addNotification(
      NotificationFactory.createModeChangeEvent(message: mode.label()),
    );
  }

  void toggleMode() {
    final mode =
        _settings.mode == PomodoroMode.standard
            ? PomodoroMode.scheduleBased
            : PomodoroMode.standard;
    _settings = _settings.updateMode(mode);
    _updateBoxDataAndNotifyListeners();
    _addNotification(
      NotificationFactory.createModeChangeEvent(message: mode.label()),
    );
  }

  void _updateSchedule(Schedule Function(Schedule) updateFunction) {
    _settings = _settings.updateSchedule(updateFunction(_settings.schedule));
    _updateBoxDataAndNotifyListeners();
  }

  void addExceptionForSchedule(DateTime date) {
    _updateSchedule((schedule) => schedule.addException(date));
  }

  void removeExceptionForSchedule(DateTime date) {
    _updateSchedule((schedule) => schedule.removeException(date));
  }

  void toggleActiveDayForSchedule(int dayIndex) {
    _updateSchedule((schedule) => schedule.toggleActiveDay(dayIndex));
  }

  void addBreakForSchedule(TimePeriod breakTime) {
    _updateSchedule((schedule) => schedule.addBreak(breakTime));
  }

  void removeBreakForSchedule(TimePeriod breakTime) {
    _updateSchedule((schedule) => schedule.removeBreak(breakTime));
  }

  void updateBreakDurationForSchedule(int newDuration) {
    _updateSchedule(
      (schedule) => schedule.updateBreakDurationInSeconds(newDuration),
    );
  }

  void updateSessionDurationForSchedule(int newDuration) {
    _updateSchedule(
      (schedule) => schedule.updateSessionDurationInSeconds(newDuration),
    );
  }

  void updateActiveTimePeriodForSchedule(TimePeriod newActiveTimePeriod) {
    _updateSchedule(
      (schedule) => schedule.updateActiveTimePeriod(newActiveTimePeriod),
    );
  }

  PomodoroSettings _loadSettings() {
    if (_box.containsKey('pomodoro_settings')) {
      return _box.get('pomodoro_settings') as PomodoroSettings;
    }
    return PomodoroSettings(
      mode: PomodoroMode.standard,
      schedule: Schedule.initial(),
    );
  }

  void _updateBoxDataAndNotifyListeners() async {
    notifyListeners();
    await _box.put('pomodoro_settings', _settings);
  }

  void _addNotification(NotificationEvent event) {
    eventBus.emit(event);
  }
}
