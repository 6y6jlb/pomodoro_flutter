import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int sessionDuration = 1500; //25 min default
  bool isRunning = true;

  CountDownTimerFormat getTimerFormat() {
    return sessionDuration > 3600
        ? CountDownTimerFormat.hoursMinutesSeconds
        : CountDownTimerFormat.minutesSeconds;
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro timer'),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    Duration(seconds: sessionDuration),
                  ),
                  onEnd: stopTimer,
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
                  onPressed: isRunning ? null : startTimer,
                  child: Text('Запуск'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
