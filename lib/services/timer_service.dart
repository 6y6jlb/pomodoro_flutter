import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import 'package:workmanager/workmanager.dart';

class TimerService {
  static const String _taskId = 'pomodoro_timer_task';

  Future<void> scheduleTimerTask(int durationInSeconds) async {
    await Workmanager().registerOneOffTask(
      _taskId,
      _taskId,
      initialDelay: Duration(seconds: durationInSeconds),
      constraints: Constraints(networkType: NetworkType.not_required),
    );
  }

  Future<void> cancelTimerTask() async {
    await Workmanager().cancelAll();
  }

  Future<void> saveRemainingTime(int remainingTime) async {
    final box = await Hive.openBox('timerState');
    await box.put('remainingTime', remainingTime);
  }

  Future<int> loadRemainingTime() async {
    final box = await Hive.openBox('timerState');
    return box.get('remainingTime', defaultValue: SettingsConstant.defaultRemaingDurationInSeconds);
  }
}
