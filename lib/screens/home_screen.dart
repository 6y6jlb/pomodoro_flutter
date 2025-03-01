import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro timer'),
        actions: [
          IconButton.filled(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen())
              );
          },
          icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: const Center(child: Text('Pomodoro app')),
    );
  }
}