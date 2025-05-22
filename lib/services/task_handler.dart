import 'package:hive/hive.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/vibration_service.dart';
import 'package:pomodoro_flutter/utils/consts/constant.dart';

@pragma('vm:entry-point')
class TaskHandler {
  @pragma('vm:entry-point')
  static Future<bool> executeTask(String task, Map<String, dynamic>? inputData) async {
    try {
      final notificationService = NotificationService();
      await notificationService.init();
      final timerStateBox = await Hive.openBox(AppConstants.timerStateBox);

      if (task == AppConstants.pomodoroTimerTask) {
        final remainingTime = timerStateBox.get('remainingTime', defaultValue: 60);
        if (remainingTime <= 0) {
          await notificationService.showNotification('Pomodoro Timer', 'Ваш таймер завершён!');
          VibrationService.vibrate(duration: 1000);
          await timerStateBox.put('remainingTime', 0);
        }
      }
      return true;
    } catch (e) {
      print('Task execution error: $e'); // В продакшене заменить на логгер
      return false;
    }
  }
}
