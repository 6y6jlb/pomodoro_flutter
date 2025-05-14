import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_flutter/exceptions/no_active_days_exception.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';

class ScheduleInfoWidget extends StatelessWidget {
  final Schedule schedule;

  const ScheduleInfoWidget({super.key, required this.schedule});

  String _getScheduleStatus(Schedule schedule) {
    return schedule.isActiveNow()
        ? I10n().t.scheduleStateLabel_active
        : I10n().t.scheduleStateLabel_inactive;
  }

  String _getScheduleDetails(Schedule schedule) {
    if (schedule.isActiveNow()) {
      final endTime = schedule.currentPeriodEnd();
      if (endTime != null) {
        return I10n().t.schedultWillEndAt(_formatTime(endTime));
      }
    } else {
      try {
        final startTime = schedule.nextPeriodStart();
        return I10n().t.scheduleWillStartAt(_formatDay(startTime), _formatTime(startTime));
      } on NoActiveDaysException {
        return I10n().t.scheduleHasNotActiveDay;
      }
    }
    return '-';
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
        Text(_getScheduleStatus(schedule), style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(_getScheduleDetails(schedule), style: AppTextStyles.caption),
      ],
    );
  }
}
