import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';
import 'package:pomodoro_flutter/utils/time_period.dart';
import 'package:pomodoro_flutter/providers/schedule_provider.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  final List<int> _daysOfWeekIndexes = [0, 1, 2, 3, 4, 5, 6];

  void _removeException(DateTime value) => Provider.of<ScheduleProvider>(
    context,
    listen: false,
  ).removeException(value);

  void _addException() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value != null) {
        Provider.of<ScheduleProvider>(
          context,
          listen: false,
        ).addException(value);
      }
    });
  }

  void _updateActiveTimePeriod(TimePeriod newPeriod) =>
      Provider.of<ScheduleProvider>(
        context,
        listen: false,
      ).updateActiveTimePeriod(newPeriod);

  void _updateBreakDuration(int newDuration) => Provider.of<ScheduleProvider>(
    context,
    listen: false,
  ).updateBreakDuration(newDuration);

  void _updateSessionDuration(int newDuration) =>
      Provider.of<ScheduleProvider>(
        context,
        listen: false,
      ).updateSessionDuration(newDuration);

  void _toggleActiveDay(int dayIndex) => Provider.of<ScheduleProvider>(
    context,
    listen: false,
  ).toggleActiveDay(dayIndex);

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<ScheduleProvider>(context).schedule;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Расписание'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        DateFormat.E().format(DateTime(2023, 10, i + 2)),
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
              'Активные часы.: ${schedule.activeTimePeriod?.start.format(context)} - ${schedule.activeTimePeriod.end.format(context)}',
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
                    setState(() {
                      _updateActiveTimePeriod(
                        TimePeriod(
                          start: start,
                          end: schedule.activeTimePeriod.end,
                        ),
                      );
                    });
                  },
                  onEndChange: (end) {
                    setState(() {
                      _updateActiveTimePeriod(
                        TimePeriod(
                          start: schedule.activeTimePeriod.start,
                          end: end,
                        ),
                      );
                    });
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
            Expanded(
              child: ListView.builder(
                itemCount: schedule.exceptionsDays.length,
                itemBuilder: (context, index) {
                  DateTime exception = schedule.exceptionsDays[index];
                  return ListTile(
                    title: Text(DateFormat('yyyy-MM-dd').format(exception)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeException(exception),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addException,
              child: const Text('Добавить исключинеие'),
            ),
          ],
        ),
      ),
    );
  }
}
