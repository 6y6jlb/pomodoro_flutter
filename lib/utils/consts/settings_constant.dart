import 'package:flutter/material.dart';

class SettingsConstant {
  static const int defaultSessionDurationInSeconds = 1500; // 25 минут
  static const int defaultBreakDurationInSeconds = 300; // 5 минут
  static const int defaultRestDelayDurationInSeconds = 300; // 5 минут
  static const int defaultRemaingDurationInSeconds = 5; // 5 секунд

  static const int minSessionDurationInSeconds = 60; // 5 минут
  static const int maxSessionDurationInSeconds = 7200; // 120 минут

  static const int minBreakDurationInSeconds = 60; // 1 минута
  static const int maxBreakDurationInSeconds = 1800; // 60 минут

  static const TimeOfDay defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const TimeOfDay defaultEndTime = TimeOfDay(hour: 17, minute: 0);

  static const List<int> defaultActiveDayIndexes = [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday];
}
