import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/schedule_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/home_screen.dart';
import 'package:pomodoro_flutter/widgets/glocal_snackbar_listener.dart';
import 'package:provider/provider.dart';

void main() {


  final scheduleProvider = ScheduleProvider();
  final settingsProvider = SettingsProvider(scheduleProvider.schedule);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => scheduleProvider),
    ChangeNotifierProvider(create: (_) => settingsProvider),
    ChangeNotifierProvider(create: (_) => ProcessingProvider(settingsProvider)),
  ], 
  child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: GlobalSnackbarListener(child: HomeScreen()),
    );
  }
}
