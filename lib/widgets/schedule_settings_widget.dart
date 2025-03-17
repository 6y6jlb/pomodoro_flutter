import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/schedule_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';
import 'package:pomodoro_flutter/utils/time_period.dart';
import 'package:pomodoro_flutter/widgets/info_block_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class ScheduleSettingsWidget extends StatelessWidget {
  const ScheduleSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> _daysOfWeekIndexes = [0, 1, 2, 3, 4, 5, 6];
    final scheduleProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final schedule = scheduleProvider.schedule;

    void _updateScheduleAndSettings(
      void Function(ScheduleProvider) updateSchedule,
    ) {
      updateSchedule(scheduleProvider);
      settingsProvider.updateFromSchedule(schedule);
    }

    void _removeException(DateTime value) {
      _updateScheduleAndSettings(
        (scheduleProvider) => scheduleProvider.removeException(value),
      );
    }

    void _addException() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      ).then((value) {
        if (value != null) {
          _updateScheduleAndSettings(
            (scheduleProvider) => scheduleProvider.addException(value),
          );
        }
      });
    }

    void _updateActiveTimePeriod(TimePeriod newPeriod) {
      _updateScheduleAndSettings(
        (scheduleProvider) =>
            scheduleProvider.updateActiveTimePeriod(newPeriod),
      );
    }

    void _updateBreakDuration(int newDuration) {
      if (newDuration < SettingsConstant.minBreakDuration ||
          newDuration > SettingsConstant.maxBreakDuration) {
        return;
      }
      _updateScheduleAndSettings(
        (scheduleProvider) => scheduleProvider.updateBreakDuration(newDuration),
      );
    }

    void _updateSessionDuration(int newDuration) {
      if (newDuration < SettingsConstant.minSessionDuration ||
          newDuration > SettingsConstant.maxSessionDuration) {
        return;
      }
      _updateScheduleAndSettings(
        (scheduleProvider) =>
            scheduleProvider.updateSessionDuration(newDuration),
      );
    }

    void _toggleActiveDay(int dayIndex) {
      _updateScheduleAndSettings(
        (scheduleProvider) => scheduleProvider.toggleActiveDay(dayIndex),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBlockWidget(
          title: 'Режим "Расписание"',
          description:
              'Настройте активные дни и часы — таймер будет работать только тогда, когда нужно.',
          color: Colors.green[50],
        ),
        const SizedBox(height: 16),
        Text(
          'Активные дни: ${schedule.activeDaysOfWeek.length}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children:
              _daysOfWeekIndexes.map((i) {
                return FilterChip(
                  label: Text(
                    DateFormat.E().format(
                      DateTime.now().add(Duration(days: i)),
                    ),
                  ),
                  selected: schedule.activeDaysOfWeek.contains(i),
                  onSelected: (isSelected) {
                    _toggleActiveDay(i);
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Активные часы.: ${schedule.activeTimePeriod.start.format(context)} - ${schedule.activeTimePeriod.end.format(context)}',
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
                _updateActiveTimePeriod(
                  TimePeriod(start: start, end: schedule.activeTimePeriod.end),
                );
              },
              onEndChange: (end) {
                _updateActiveTimePeriod(
                  TimePeriod(start: schedule.activeTimePeriod.start, end: end),
                );
              },
            );
          },
          child: const Text("Указать период активности"),
        ),
        Text(
          'Сессия длительность мин.: ${schedule.sessionDuration ~/ 60}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: schedule.sessionDuration.toDouble(),
          min: SettingsConstant.minSessionDuration.toDouble(),
          max: SettingsConstant.maxSessionDuration.toDouble(),
          onChanged: (value) {
            _updateSessionDuration(value.toInt());
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Перервыв длительность мин.: ${schedule.breakDuration ~/ 60}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: schedule.breakDuration.toDouble(),
          min: SettingsConstant.minBreakDuration.toDouble(),
          max: SettingsConstant.maxBreakDuration.toDouble(),
          onChanged: (value) {
            _updateBreakDuration(value.toInt());
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Исключения: ${schedule.exceptionsDays.length}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _addException,
          child: const Text('Добавить исключинеие'),
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
                          title: Text('Исключения'),
                          content: Consumer<ScheduleProvider>(
                            builder: (context, scheduleProvider, _) {
                              return Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemCount: scheduleProvider.schedule.exceptionsDays.length,
                                  itemBuilder: (context, index) {
                                    DateTime exception =
                                        schedule.exceptionsDays[index];
                                    return ListTile(
                                      title: Text(
                                        DateFormat('yyyy-MM-dd').format(exception),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed:
                                            () => _removeException(exception),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
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
          child: const Text('Посмотреть исключения'),
        ),
      ],
    );
  }
}
