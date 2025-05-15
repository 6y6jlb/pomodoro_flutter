import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/alert_level.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import 'package:pomodoro_flutter/widgets/info_block_widget.dart';
import 'package:provider/provider.dart';

class StandartSettingsWidget extends StatelessWidget {
  const StandartSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoBlockWidget(
           title:
              "${I10n().t.operationModeLabel} ${I10n().t.pomodoroModeLabel_custom}",
          description:
              I10n().t.scheduleCustomModeDescription,
          level: AlertLevel.info,
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.sessionDurationLabel} ${settings.userSessionDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: settings.userSessionDurationInSeconds.toDouble(),
          min: SettingsConstant.minSessionDurationInSeconds.toDouble(),
          max: SettingsConstant.maxSessionDurationInSeconds.toDouble(),
          onChanged: (value) {
            Provider.of<SettingsProvider>(
              context,
              listen: false,
            ).updateUserSesstionDuration(value.toInt());
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${I10n().t.breakDurationLabel} ${settings.userBreakDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}',
          style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: settings.userBreakDurationInSeconds.toDouble(),
          min: SettingsConstant.minBreakDurationInSeconds.toDouble(),
          max: SettingsConstant.maxBreakDurationInSeconds.toDouble(),
          onChanged: (value) {
            Provider.of<SettingsProvider>(
              context,
              listen: false,
            ).updateUserBreaknDuration(value.toInt());
          },
        ),
      ],
    );
  }
}
