import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodoro_flutter/services/hive_service.dart';
import 'package:pomodoro_flutter/services/workmanager_service.dart';

class AppInitializer {
  static Future<void> initializeApp({bool isBackground = false}) async {
    if (!isBackground) {
      await _initializeForeground();
    }
    await _initializeHive();
  }

  static Future<void> _initializeForeground() async {
    await Permission.notification.request();
    await initializeDateFormatting('ru_RU', null);
    WorkmanagerService.initialize();
  }

  static Future<void> _initializeHive({bool isBackground = false}) async {
    await HiveService.initialize();
    if (!isBackground) {
      await HiveService.openBox('settings');
    }
    await HiveService.openBox('timerState');
  }

  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }
}
