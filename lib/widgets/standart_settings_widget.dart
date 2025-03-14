import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/utils/settings_constant.dart';
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
          title: 'Режим "Пользовательский"',
          description:
              'Выбирайте длительность работы и отдыха без привязки к графику.',
          color: Colors.blue[50],
        ),
        const SizedBox(height: 16),
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
      ],
    );
  }
}
