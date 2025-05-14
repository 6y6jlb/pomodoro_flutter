import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';
import 'package:pomodoro_flutter/widgets/info_block_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ScheduleSettingsWidget extends StatelessWidget {
  const ScheduleSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final schedule = settingsProvider.settings.schedule;

    void addException() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ).then((value) {
        if (value != null) {
          settingsProvider.addExceptionForSchedule(value);
        }
      });
    }



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBlockWidget(
          title: "${I10n().t.operationModeLabel} ${I10n().t.pomoodoroModeLabel_schedule}",
          description:
              I10n().t.scheduleScheduleModeDesctiption,
          color: Colors.green[50],
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.scheduleActiveDaysLabel} ${schedule.activeDaysOfWeek.length}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            return FilterChip(
              label: Text(
          DateFormat('EEE').format(
            DateTime.now().add(Duration(days: (index - DateTime.now().weekday + 7) % 7)),
          ),
              ),
              selected: schedule.activeDaysOfWeek.contains(index),
              onSelected: (isSelected) {
          settingsProvider.toggleActiveDayForSchedule(index);
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.scheduleActiveHoursLabel} ${schedule.activeTimePeriod.start.format(context)} - ${schedule.activeTimePeriod.end.format(context)}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            showTimeRangePicker(
              context: context,
              start: schedule.activeTimePeriod.start,
              end: schedule.activeTimePeriod.end,
              interval: const Duration(minutes: 30),
              minDuration: const Duration(minutes: 30),
              use24HourFormat: false,
              padding: 30,
              strokeWidth: 20,
              handlerRadius: 14,
              strokeColor: Colors.green[300],
              handlerColor: Colors.green[300],
              selectedColor: Colors.green,
              disabledColor: Colors.blueGrey[100],
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.amber),
              ticks: 24,
              onStartChange: (start) {
                settingsProvider.updateActiveTimePeriodForSchedule(
                  TimePeriod(start: start, end: schedule.activeTimePeriod.end),
                );
              },
              onEndChange: (end) {
                settingsProvider.updateActiveTimePeriodForSchedule(
                  TimePeriod(start: schedule.activeTimePeriod.start, end: end),
                );
              },
            );
          },
          child: Text(I10n().t.scheduleActiveDaysLabel),
        ),
        Text(
          '${I10n().t.sesstionDuretionLabel} ${schedule.sessionDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: schedule.sessionDurationInSeconds.toDouble(),
          min: SettingsConstant.minSessionDurationInSeconds.toDouble(),
          max: SettingsConstant.maxSessionDurationInSeconds.toDouble(),
          onChanged: (value) {
            settingsProvider.updateSessionDurationForSchedule(value.toInt());
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.breakDurationLabel} ${schedule.breakDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: schedule.breakDurationInSeconds.toDouble(),
          min: SettingsConstant.minBreakDurationInSeconds.toDouble(),
          max: SettingsConstant.maxBreakDurationInSeconds.toDouble(),
          onChanged: (value) {
            settingsProvider.updateBreakDurationForSchedule(value.toInt());
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.scheduleExceptionsLabel} ${schedule.exceptionsDays.length}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: addException,
          child: Text(I10n().t.scheduleExceptionAddLabel),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:
              schedule.exceptionsDays.isNotEmpty
                  ? () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          title: Text(I10n().t.scheduleExceptionsLabel),
                          content: Consumer<SettingsProvider>(
                            builder: (context, settingsProvider, _) {
                              final schedule =
                                  settingsProvider.settings.schedule;

                              return SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemCount: schedule.exceptionsDays.length,
                                  itemBuilder: (context, index) {
                                    DateTime exception =
                                        schedule.exceptionsDays[index];
                                    return ListTile(
                                      title: Text(
                                        DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(exception),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed:
                                            () => settingsProvider
                                                .removeExceptionForSchedule(
                                                  exception,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  : null,
          child: Text(I10n().t.scheduleExceptionShowLabel),
        ),
      ],
    );
  }
}
