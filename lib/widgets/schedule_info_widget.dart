import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';

class ScheduleInfoWidget extends StatelessWidget {
  final Schedule schedule;

  const ScheduleInfoWidget({super.key, required this.schedule});

  String _getScheduleStatus(Schedule schedule) {
    return schedule.isActiveNow()
        ? 'Расписание: активно'
        : 'Расписание: неактивно';
  }

  String _getScheduleDetails(Schedule schedule) {
    if (schedule.isActiveNow()) {
      final endTime = schedule.currentPeriodEnd();
      if (endTime != null) {
        return 'Закончится в ${_formatTime(endTime)}';
      }
    } else {
      try {
        final startTime = schedule.nextPeriodStart();
        return 'Начнется ${_formatDay(startTime)}, в ${_formatTime(startTime)}';
      } catch (e) {
        return 'Нет активных дней в расписании';
      }
    }
    return '';
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDay(DateTime dateTime) {
    final formatter = DateFormat('EEEE', 'ru_RU');
    return formatter.format(dateTime);
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _getScheduleStatus(schedule),
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 4),
        Text(_getScheduleDetails(schedule), style: AppTextStyles.caption),
      ],
    );
  }
}