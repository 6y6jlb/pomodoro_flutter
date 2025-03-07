import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:provider/provider.dart';


class ModeSwitcher extends StatefulWidget {
  const ModeSwitcher({
    super.key,
    required this.context,
    required this.settings,
  });

  final BuildContext context;
  final PomodoroSettings settings;



  @override
  State<ModeSwitcher> createState() => _ModeSwitcherState();
}

class _ModeSwitcherState extends State<ModeSwitcher> {

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

       String _getNotificationMessage(PomodoroMode mode) {
    return 'Текущий режим: ${mode == PomodoroMode.scheduleBased ? "Расписание" : "Стандарт"}';
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Расписание: ', style: TextStyle(fontSize: 18)),
        Switch(
          thumbIcon: thumbIcon,
          value: widget.settings.mode == PomodoroMode.scheduleBased,
          onChanged: (value) {
            final newMode = value ? PomodoroMode.scheduleBased : PomodoroMode.standard;
            Provider.of<SettingsProvider>(context, listen: false).updateMode(newMode);
            Provider.of<NotificationProvider>(context, listen: false).addNotification(_getNotificationMessage(newMode));
          },
        ),
      ],
    );
  }
}