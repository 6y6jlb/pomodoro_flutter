import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'time_period.g.dart';

@HiveType(typeId: 0)
class TimePeriod {
  @HiveField(0)
  final TimeOfDay start;

  @HiveField(1)
  final TimeOfDay end;

  TimePeriod({required this.start, required this.end});

  @override
  String toString() {
    return '${start.hour}:${start.minute}-${end.hour}:${end.minute}';
  }

  factory TimePeriod.fromString(String value) {
    final parts = value.split('-');
    if (parts.length != 2) {
      throw FormatException('Invalid TimePeriod format');
    }

    final startParts = parts[0].split(':');
    final endParts = parts[1].split(':');

    if (startParts.length != 2 || endParts.length != 2) {
      throw FormatException('Invalid TimePeriod format');
    }

    final startHour = int.tryParse(startParts[0]) ?? 0;
    final startMinute = int.tryParse(startParts[1]) ?? 0;
    final endHour = int.tryParse(endParts[0]) ?? 0;
    final endMinute = int.tryParse(endParts[1]) ?? 0;

    return TimePeriod(
      start: TimeOfDay(hour: startHour, minute: startMinute),
      end: TimeOfDay(hour: endHour, minute: endMinute),
    );
  }
}
