import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:pomodoro_flutter/providers/processing_provider.dart';
import 'package:pomodoro_flutter/providers/settings_provider.dart';
import 'package:pomodoro_flutter/services/app_initializer.dart';
import 'package:pomodoro_flutter/widgets/app.dart';
import 'package:provider/provider.dart';

void main() async {
  // Инициализируем Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeApp();

  // Создаем провайдеры
  final settingsProvider = SettingsProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider(), lazy: false),
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
