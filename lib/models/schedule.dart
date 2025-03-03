import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_flutter/models/time_period.dart';

class Schedule {
  final List<int> activeDaysOfWeek;
  final List<DateTime> exceptionsDays;
  final List<TimePeriod> plannedTimeBreaks;
  final TimePeriod activeTimePeriod;
  final int breakDuration;

  Schedule({
    required this.activeDaysOfWeek,
    required this.exceptionsDays,
    required this.breakDuration,
    required this.plannedTimeBreaks,
    required this.activeTimePeriod,
  });

  bool isActiveNow() {
    final now = DateTime.now();
    return isActiveDay(now) && isActiveTime(now);
  }

  bool isActiveDay(DateTime date) {
    final dayOfWeek = DateFormat('EEE').format(date).toLowerCase();
    if (!activeDaysOfWeek.contains(dayOfWeek)) {
      return false;
    }

    for (var exception in exceptionsDays) {
      if (exception.isAtSameMomentAs(date)) {
        return false;
      }
    }
    return true;
  }

  bool isActiveTime(DateTime date) {
    final timeOfDay = TimeOfDay.fromDateTime(date);

    final activeStart = activeTimePeriod?.start;
    final activeEnd = activeTimePeriod?.end;

    if (activeStart == null || activeEnd == null) return true;

    if (!timeIsBetween(timeOfDay, activeStart, activeEnd)) return false;

    for (var breakTime in plannedTimeBreaks) {
      if (timeIsBetween(timeOfDay, breakTime.start, breakTime.end)) {
        return false;
      }
    }

    return true;
  }

  bool timeIsBetween(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final nowTime = time.hour * 60 + time.minute;
    final startTime = start.hour * 60 + start.minute;
    final endTime = end.hour * 60 + end.minute;

    return nowTime >= startTime && nowTime <= endTime;
  }

  Schedule addException(DateTime date) {
    final newExceptions = List<DateTime>.from(exceptionsDays)..add(date);
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: newExceptions,
      breakDuration: breakDuration,
      plannedTimeBreaks: plannedTimeBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule removeException(DateTime date) {
    final newExceptions =
        exceptionsDays.where((e) => e.isAtSameMomentAs(date) == false).toList();
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: newExceptions,
      breakDuration: breakDuration,
      plannedTimeBreaks: plannedTimeBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule toggleActiveDay(int dayIndex) {
    final newDays = List<int>.from(activeDaysOfWeek);
    if (newDays.contains(dayIndex)) {
      newDays.remove(dayIndex);
    } else {
      newDays.add(dayIndex);
    }
    return Schedule(
      activeDaysOfWeek: newDays,
      exceptionsDays: exceptionsDays,
      breakDuration: breakDuration,
      plannedTimeBreaks: plannedTimeBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule addBreak(TimePeriod breakTime) {
    final newBreaks = List<TimePeriod>.from(plannedTimeBreaks)..add(breakTime);
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: exceptionsDays,
      breakDuration: breakDuration,
      plannedTimeBreaks: newBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule removeBreak(TimePeriod breakTime) {
    final newBreaks = plannedTimeBreaks.where((b) => b != breakTime).toList();
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: exceptionsDays,
      breakDuration: breakDuration,
      plannedTimeBreaks: newBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule updateBreakDuration(int newDuration) {
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: exceptionsDays,
      breakDuration: newDuration,
      plannedTimeBreaks: plannedTimeBreaks,
      activeTimePeriod: activeTimePeriod,
    );
  }

  Schedule updateActiveTimePeriod(TimePeriod newActiveTimePeriod) {
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek,
      exceptionsDays: exceptionsDays,
      breakDuration: breakDuration,
      plannedTimeBreaks: plannedTimeBreaks,
      activeTimePeriod: newActiveTimePeriod,
    );
  }
}
