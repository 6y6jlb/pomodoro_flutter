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
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/theme/allert_colors.dart';
import 'package:pomodoro_flutter/theme/processing_colors.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';
import 'package:pomodoro_flutter/widgets/listeners/global_delayed_action_listener.dart';
import 'package:pomodoro_flutter/widgets/listeners/global_snackbar_listener.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // Инициализируем Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PomodoroModeAdapter());
  Hive.registerAdapter(TimePeriodAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(PomodoroSettingsAdapter());

  await Hive.openBox('settings');

  // Инициализируем локализацию
  await initializeDateFormatting('ru_RU', null);

  // Создаем провайдеры
  final settingsProvider = SettingsProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProxyProvider<SettingsProvider, ProcessingProvider>(
          create: (_) => ProcessingProvider(settingsProvider.settings),
          update: (context, settingsProvider, processingProvider) {
            processingProvider?.updateSettings(settingsProvider.settings);
            return processingProvider!;
          },
        ),
      ],
      child: App(),
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[400],
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green[400],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
         extensions: [
          AlertColors(
            info: Colors.blue.shade800,
            warning: Colors.orange.shade800,
            success: Colors.green.shade800,
            danger: Colors.red.shade800,
          ),
          ProcessingColors(
            activity: Colors.green[300]!,
            inactivity: Colors.grey[500]!,
            rest: Colors.blue[400]!,
            restDelay: Colors.deepPurple[300]!,
          ),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green[800]!,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[900], 
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green[800],
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
          extensions: [
          AlertColors(
            info: Colors.blue.shade800,
            warning: Colors.orange.shade800,
            success: Colors.green.shade800,
            danger: Colors.red.shade800,
          ),
          ProcessingColors(
            activity: Colors.green[800]!,
            inactivity: Colors.grey[700]!,
            rest: Colors.blue[900]!,
            restDelay: Colors.deepPurple[800]!,
          ),
        ],
      ),
      themeMode: ThemeMode.system,
      home: GlobalDelayedActionListener(
        child: GlobalSnackbarListener(child: HomeScreen()),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale('en', '');
      },
      builder: (context, child) {
        // Инициализация сервиса локализации
        I10n().initialize(context);
        return child!;
      },
    );
  }
}
