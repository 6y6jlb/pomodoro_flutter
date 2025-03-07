import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/schedule_screen.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';
import 'package:pomodoro_flutter/widgets/mode_switcher.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Настройки'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Сессия длительность мин.: ${settings.userSessionDuration ~/ 60}',
              style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: settings.userSessionDuration.toDouble(),
              min: SettingsConstant.minSessionDuration.toDouble(),
              max: SettingsConstant.maxSessionDuration.toDouble(),
              onChanged: (value) {
                Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                ).updateUserSesstionDuration(value.toInt());
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Перервыв длительность мин.: ${settings.userBreakDuration ~/ 60}',
              style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: settings.userBreakDuration.toDouble(),
              min: SettingsConstant.minBreakDuration.toDouble(),
              max: SettingsConstant.maxBreakDuration.toDouble(),
              onChanged: (value) {
                Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                ).updateUserBreaknDuration(value.toInt());
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ModeSwitcher(context: context, settings: settings),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleScreen(),
                  ),
                );
              },
              child: const Text('Задать расписание'),
            ),
          ],
        ),
      ),
    );
  }
}
