import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';
import 'package:pomodoro_flutter/utils/app_text_styles.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/animated_circle_times.dart';
import 'package:pomodoro_flutter/widgets/timer_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final processingProvider = Provider.of<ProcessingProvider>(context);
    final settings = settingsProvider.settings;
    final processing = processingProvider.processing;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Режим: ${settings.mode.label()}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  'Сессия: ${settings.currentSessionDurationInSeconds ~/ 60} мин.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  'Перерыв: ${settings.currentBreakDurationInSeconds ~/ 60} мин.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 30),
                TimerWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
