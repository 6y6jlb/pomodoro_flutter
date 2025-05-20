import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode_adapter.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/vibration_service.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';
import 'package:pomodoro_flutter/widgets/app.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';


void main() async {
  // Инициализируем Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();

  // Инициализируем Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PomodoroModeAdapter());
  Hive.registerAdapter(TimePeriodAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(PomodoroSettingsAdapter());

  await Hive.openBox('settings');
  await Hive.openBox('timerState');

  // Инициализируем локализацию
  await initializeDateFormatting('ru_RU', null);


  // Инициализация Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

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

Future<void> requestPermissions() async {
  await Permission.notification.request();
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    Hive.registerAdapter(PomodoroModeAdapter());
    Hive.registerAdapter(TimePeriodAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(PomodoroSettingsAdapter());
    final timerStateBox = await Hive.openBox('timerState');

    final notificationService = NotificationService();
    await notificationService.init();

    if (task == 'pomodoro_timer_task') {
      final remainingTime = timerStateBox.get('remainingTime', defaultValue: 60);

      if (remainingTime <= 0) {
        await notificationService.showNotification(
          'Pomodoro Timer',
          'Ваш таймер завершён!',
        );
        VibrationService.vibrate(duration: 1000);
        await timerStateBox.put('remainingTime', 0);
      }
    }

    return Future.value(true);
  });
}