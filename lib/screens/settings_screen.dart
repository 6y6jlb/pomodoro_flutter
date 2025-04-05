import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/widgets/schedule_settings_widget.dart';
import 'package:pomodoro_flutter/widgets/standart_settings_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;

    String getNotificationMessage(PomodoroMode mode) {
      return 'Текущий режим: ${mode.label()}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Режим работы:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: settings.mode.name,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: Container(height: 1, color: Colors.green[200]),
                  onChanged: (String? value) {
                    PomodoroMode newMode =
                        value == PomodoroMode.scheduleBased.name
                            ? PomodoroMode.scheduleBased
                            : PomodoroMode.standard;
                    Provider.of<SettingsProvider>(
                      context,
                      listen: false,
                    ).updateMode(newMode);
                    GlobalNotificationStream.addNotification(getNotificationMessage(newMode));
                  },
                  items:
                      PomodoroMode.values.map<DropdownMenuItem<String>>((
                        PomodoroMode pm,
                      ) {
                        return DropdownMenuItem<String>(
                          value: pm.name,
                          child: Text(pm.label()),
                        );
                      }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            settings.mode == PomodoroMode.scheduleBased
                ? ScheduleSettingsWidget()
                : StandartSettingsWidget(),
          ],
        ),
      ),
    );
  }
}
