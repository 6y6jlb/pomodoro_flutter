import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/styles/app_text_styles.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/widgets/schedule_info_widget.dart';
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
        title: Text(processing.state.label(), style: AppTextStyles.title),
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
                  "${I10n().t.operationModeLabel} ${settings.mode.label()}",
                  style: AppTextStyles.caption,
                ),

                const SizedBox(height: 4),
                if (settings.mode != PomodoroMode.standard)
                  ScheduleInfoWidget(schedule: settings.schedule),
                const SizedBox(height: 4),
                Text(
                  "${I10n().t.sesstionDuretionLabel} ${settings.currentSessionDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}",
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  "${I10n().t.breakDurationLabel} ${settings.currentBreakDurationInSeconds ~/ 60} ${I10n().t.unitShort_minute}",
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
