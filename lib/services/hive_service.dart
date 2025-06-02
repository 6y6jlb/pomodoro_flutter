import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_flutter/enums/pomodoro_mode_adapter.dart';
import 'package:pomodoro_flutter/enums/processing_state_adapter.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/models/schedule.dart';
import 'package:pomodoro_flutter/utils/datetime/time_period.dart';

class HiveService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PomodoroModeAdapter());
    Hive.registerAdapter(ProcessingStateAdapter());
    Hive.registerAdapter(TimePeriodAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(PomodoroSettingsAdapter());
    Hive.registerAdapter(ProcessingAdapter());
  }

  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }
}
