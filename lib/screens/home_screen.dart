import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';
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
          _buildTimer(context, settings, processing),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTimer(
    BuildContext context,
    PomodoroSettings settings,
    Processing processing,
  ) {
    Stream<int> createTimerStream(int durationInSeconds) {
      return Stream.periodic(
        const Duration(seconds: 1),
        (count) => durationInSeconds - count,
      ).take(durationInSeconds + 1);
    }

    return Center(
      child: Column(
        children: [
          Text('Сессия: ${settings.currentSessionDurationInSeconds ~/ 60} мин.',),
          const SizedBox(height: 4),
          Text('Перерыв: ${settings.currentBreakDurationInSeconds ~/ 60} мин.'),
          const SizedBox(height: 8),
          Text(processing.state.label()),
          processing.state.hasTimer()
              ? StreamBuilder<int>(
                stream: createTimerStream(processing.periodDurationInSeconds),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text(
                      '00:00',
                      style: TextStyle(fontSize: 48, color: Colors.green[400]),
                    );
                  }

                  final remainingSeconds = snapshot.data!;
                  final minutes = remainingSeconds ~/ 60;
                  final seconds = remainingSeconds % 60;

                  return Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 48, color: Colors.green[300]),
                  );
                },
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
                    processing.state.hasTimer()
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
                    processing.state.hasTimer()
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
