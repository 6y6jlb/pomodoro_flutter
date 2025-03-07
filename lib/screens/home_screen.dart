import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';
import 'package:pomodoro_flutter/utils/enums/pomodoro_mode.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
import 'package:pomodoro_flutter/widgets/mode_switcher.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ModeSwitcher(context: context, settings: settings),

            const SizedBox(height: 20),

            _buildTimer(context, settings, processing),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(
    BuildContext context,
    PomodoroSettings settings,
    Processing processing,
  ) {
    CountDownTimerFormat getTimerFormat() {
      return settings.currentBreakDuration > 3600
          ? CountDownTimerFormat.hoursMinutesSeconds
          : CountDownTimerFormat.minutesSeconds;
    }

    final isRunning = ProcessingState.hasTimer().contains(processing.state);

    return Center(
      child: Column(
        children: [
          Text('Сессия: ${settings.currentSessionDuration ~/ 60} мин.'),
          const SizedBox(height: 8),
          Text('Перерыв: ${settings.currentBreakDuration ~/ 60} мин.'),
          const SizedBox(height: 8),
          Text(isRunning ? 'Оставшееся время' : 'Таймер'),
          SizedBox(height: 10),
          isRunning
              ? TimerCountdown(
                enableDescriptions: false,
                format: getTimerFormat(),
                timeTextStyle: TextStyle(
                  fontSize: 48,
                  color: Colors.green[300],
                ),
                endTime: DateTime.now().add(
                  Duration(seconds: settings.currentSessionDuration),
                ),
                onEnd: Provider.of<ProcessingProvider>(context).makeInactive,
              )
              : Text(
                '00:00',
                style: TextStyle(fontSize: 48, color: Colors.green[400]),
              ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    isRunning
                        ? null
                        : Provider.of<ProcessingProvider>(
                          context,
                          listen: false,
                        ).makeActive,

                child: Text('Запуск'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed:
                    isRunning
                        ? Provider.of<ProcessingProvider>(context).makeInactive
                        : null,
                child: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
