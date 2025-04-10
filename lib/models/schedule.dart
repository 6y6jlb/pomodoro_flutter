import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';
import 'package:pomodoro_flutter/utils/time_period.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1)
class Schedule {
  @HiveField(0)
  final List<int> activeDaysOfWeek;

  @HiveField(1)
  final List<DateTime> exceptionsDays;

  @HiveField(2)
  final List<TimePeriod> plannedTimeBreaks;

  @HiveField(3)
  final TimePeriod activeTimePeriod;

  @HiveField(4)
  final int breakDurationInSeconds;

  @HiveField(5)
  final int sessionDurationInSeconds;

  Schedule({
    required this.activeDaysOfWeek,
    required this.exceptionsDays,
    required this.breakDurationInSeconds,
    required this.plannedTimeBreaks,
    required this.activeTimePeriod,
    required this.sessionDurationInSeconds,
  });

  bool isActiveNow() {
    final now = DateTime.now();
    return isActiveDay(now) && isActiveTime(now);
  }

  bool isActiveDay(DateTime date) {
    print(activeDaysOfWeek);
    print(date.weekday);
    if (!activeDaysOfWeek.contains(date.weekday)) {
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

    final activeStart = activeTimePeriod.start;
    final activeEnd = activeTimePeriod.end;

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
    return copyWith(
      exceptionsDays: List<DateTime>.from(exceptionsDays)..add(date),
    );
  }

  Schedule removeException(DateTime date) {
    return copyWith(
      exceptionsDays:
          exceptionsDays
              .where((e) => e.isAtSameMomentAs(date) == false)
              .toList(),
    );
  }

  Schedule toggleActiveDay(int dayIndex) {
    final newDays = List<int>.from(activeDaysOfWeek);
    if (newDays.contains(dayIndex)) {
      newDays.remove(dayIndex);
    } else {
      newDays.add(dayIndex);
    }
    return copyWith(activeDaysOfWeek: newDays);
  }

  Schedule addBreak(TimePeriod breakTime) {
    return copyWith(
      plannedTimeBreaks: List<TimePeriod>.from(plannedTimeBreaks)
        ..add(breakTime),
    );
  }

  Schedule removeBreak(TimePeriod breakTime) {
    return copyWith(
      plannedTimeBreaks:
          plannedTimeBreaks.where((b) => b != breakTime).toList(),
    );
  }

  Schedule updateBreakDurationInSeconds(int newDurationInSeconds) {
    return copyWith(breakDurationInSeconds: newDurationInSeconds);
  }

  Schedule updateSessionDurationInSeconds(int newDurationInSeconds) {
    return copyWith(sessionDurationInSeconds: newDurationInSeconds);
  }

  Schedule updateActiveTimePeriod(TimePeriod newActiveTimePeriod) {
    return copyWith(activeTimePeriod: newActiveTimePeriod);
  }

  Schedule copyWith({
    List<int>? activeDaysOfWeek,
    List<DateTime>? exceptionsDays,
    TimePeriod? activeTimePeriod,
    List<TimePeriod>? plannedTimeBreaks,
    int? breakDurationInSeconds,
    int? sessionDurationInSeconds,
  }) {
    return Schedule(
      activeDaysOfWeek: activeDaysOfWeek ?? this.activeDaysOfWeek,
      exceptionsDays: exceptionsDays ?? this.exceptionsDays,
      breakDurationInSeconds:
          breakDurationInSeconds ?? this.breakDurationInSeconds,
      plannedTimeBreaks: plannedTimeBreaks ?? this.plannedTimeBreaks,
      activeTimePeriod: activeTimePeriod ?? this.activeTimePeriod,
      sessionDurationInSeconds:
          sessionDurationInSeconds ?? this.sessionDurationInSeconds,
    );
  }

  static Schedule initial() {
    return Schedule(
      activeDaysOfWeek: SettingsConstant.defaultActiveDayIndexes,
      exceptionsDays: [],
      breakDurationInSeconds: SettingsConstant.defaultBreakDurationInSeconds,
      sessionDurationInSeconds:
          SettingsConstant.defaultSessionDurationInSeconds,
      plannedTimeBreaks: [],
      activeTimePeriod: TimePeriod(
        start: SettingsConstant.defaultStartTime,
        end: SettingsConstant.defaultEndTime,
      ),
    );
  }
}
