import 'package:flutter/material.dart';

class SettingsConstant {
  static const int defaultSessionDuration = 1500; // 25 минут
  static const int defaultBreakDuration = 300; // 5 минут

  static const int minSessionDuration = 300; // 5 минут
  static const int maxSessionDuration = 7200; // 120 минут

  static const int minBreakDuration = 60; // 1 минута
  static const int maxBreakDuration = 1800; // 60 минут

  static const TimeOfDay defaultStartTime = TimeOfDay(hour: 9, minute: 0);
  static const TimeOfDay defaultEndTime = TimeOfDay(hour: 17, minute: 0);

  static const List<int> defaultActiveDayIndexes = [0, 1, 2, 3, 4];
}
