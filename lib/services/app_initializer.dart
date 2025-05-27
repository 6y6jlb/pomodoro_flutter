import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodoro_flutter/services/hive_service.dart';
import 'package:pomodoro_flutter/services/workmanager_service.dart';
import 'package:pomodoro_flutter/utils/consts/constant.dart';

class AppInitializer {
  static bool _isWorkmanagerInitialized = false;

  static Future<void> initializeApp({bool isBackground = false}) async {
    if (!isBackground) {
      await _initializeForeground();
    }
    await _initializeHive(isBackground: isBackground);
  }

  static Future<void> _initializeForeground() async {
    print('Foreground initialization');
    await Permission.notification.request();
    await initializeDateFormatting('ru_RU', null);
    if (!_isWorkmanagerInitialized) {
      WorkmanagerService.initialize();
      _isWorkmanagerInitialized = true;
    }
  }

  static Future<void> _initializeHive({bool isBackground = false}) async {
    await HiveService.initialize();
    if (!isBackground) {
      await HiveService.openBox('settings');
    }
    final timerBox = await HiveService.openBox(AppConstants.timerStateBox);
    await timerBox.clear();
  }

  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }
}
