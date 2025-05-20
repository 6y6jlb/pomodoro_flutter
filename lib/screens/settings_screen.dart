import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(I10n().t.settingsScreenTitle, style: AppTextStyles.title),
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
                  I10n().t.operationModeLabel,
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
                    eventBus.emit(
                      NotificationFactory.createModeChangeEvent(
                        message: newMode.label(),
                      ),
                    );
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
