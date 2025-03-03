import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/screens/schedule_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Настройки'),
      ),
      body: Center(
        child: Center(
          child: ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleScreen()));
          }, child: const Text('Задать расписание')),
        ),
      ),
    );
  }
}