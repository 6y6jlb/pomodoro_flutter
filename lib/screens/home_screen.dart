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
        (count) => count,
      ).take(durationInSeconds + 1);
    }

    return Center(
      child: Column(
        children: [
          Text(
            'Сессия: ${settings.currentSessionDurationInSeconds ~/ 60} мин.',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 4),
          Text(
            'Перерыв: ${settings.currentBreakDurationInSeconds ~/ 60} мин.',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            processing.state.label(),
            style: TextStyle(
              fontSize: 20,
              color: processing.state.colorLevel(),
            ),
          ),
          processing.state.hasTimer()
              ? StreamBuilder<int>(
                key: ValueKey(processing.state),
                stream: createTimerStream(processing.periodDurationInSeconds),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text(
                      '00:00',
                      style: TextStyle(
                        fontSize: 48,
                        color: processing.state.colorLevel(),
                      ),
                    );
                  }

                  final passedSeconds = snapshot.data ?? 0;

                  if (passedSeconds == processing.periodDurationInSeconds) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<ProcessingProvider>(
                        context,
                        listen: false,
                      ).makeNextPeriod();
                    });
                  }

                  final remains =
                      processing.periodDurationInSeconds - passedSeconds;
                  final minutes = remains ~/ 60;
                  final seconds = remains % 60;

                  return Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 48, color: processing.state.colorLevel(),
                    ),
                  );
                },
              )
              : Text(
                '00:00',
                style: TextStyle(
                  fontSize: 48,
                  color: processing.state.colorLevel(),
                ),
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
