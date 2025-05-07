import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/screens/home_screen.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode_adapter.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';
import 'package:pomodoro_flutter/widgets/listeners/global_snackbar_listener.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PomodoroModeAdapter());
  Hive.registerAdapter(TimePeriodAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(PomodoroSettingsAdapter());

  await Hive.openBox('settings');

  final settingsProvider = SettingsProvider();

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProxyProvider<SettingsProvider, ProcessingProvider>(
          create: (_) => ProcessingProvider(settingsProvider.settings),
          update: (context, settingsProvider, processingProvider) {
            processingProvider?.updateSettings(settingsProvider.settings);
            return processingProvider!;
          },
        ),
      ],
      child: const App(),
    ),
  );
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
