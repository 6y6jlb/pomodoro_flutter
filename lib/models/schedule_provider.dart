import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/time_period.dart';
import 'schedule.dart';

class ScheduleProvider with ChangeNotifier {
  Schedule _schedule = Schedule(
    activeDaysOfWeek: [0, 1, 2, 3, 4], // Пн-Пт
    exceptionsDays: [],
    breakDuration: 300, // 5 минут
    plannedTimeBreaks: [],
    activeTimePeriod: TimePeriod(
      start: TimeOfDay(hour: 9, minute: 0),
      end: TimeOfDay(hour: 17, minute: 0),
    ),
  );

  Schedule get schedule => _schedule;

  void addException(DateTime date) {
    _schedule = _schedule.addException(date);
    notifyListeners();
  }

  void removeException(DateTime date) {
    _schedule = _schedule.removeException(date);
    notifyListeners();
  }

  void toggleActiveDay(int dayIndex) {
    _schedule = _schedule.toggleActiveDay(dayIndex);
    notifyListeners();
  }

  void addBreak(TimePeriod breakTime) {
    _schedule = _schedule.addBreak(breakTime);
    notifyListeners();
  }

  void removeBreak(TimePeriod breakTime) {
    _schedule = _schedule.removeBreak(breakTime);
    notifyListeners();
  }

  void updateBreakDuration(int newDuration) {
    _schedule = _schedule.updateBreakDuration(newDuration);
    notifyListeners();
  }

  void updateActiveTimePeriod(TimePeriod newActiveTimePeriod) {
    _schedule = _schedule.updateActiveTimePeriod(newActiveTimePeriod);
    notifyListeners();
  }
}
