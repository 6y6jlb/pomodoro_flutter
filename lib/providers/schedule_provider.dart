import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/utils/time_period.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  Schedule _schedule = Schedule.initial();

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
    _schedule = _schedule.updateBreakDurationInSeconds(newDuration);
    notifyListeners();
  }

  void updateSessionDuration(int newDuration) {
    _schedule = _schedule.updateSessionDurationInSeconds(newDuration);
    notifyListeners();
  }

  void updateActiveTimePeriod(TimePeriod newActiveTimePeriod) {
    _schedule = _schedule.updateActiveTimePeriod(newActiveTimePeriod);
    notifyListeners();
  }
}
