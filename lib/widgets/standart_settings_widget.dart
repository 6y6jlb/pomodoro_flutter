import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
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
          title: 'Режим "Пользовательский"',
          description:
              'Выбирайте длительность работы и отдыха без привязки к графику.',
          color: Colors.blue[50],
        ),
        const SizedBox(height: 16),
        Text(
          'Сессия длительность мин.: ${settings.userSessionDurationInSeconds ~/ 60}',
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
          'Перервыв длительность мин.: ${settings.userBreakDurationInSeconds ~/ 60}',
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
