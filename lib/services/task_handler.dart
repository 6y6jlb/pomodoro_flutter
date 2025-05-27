import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/processing_service.dart';
import 'package:pomodoro_flutter/services/vibration_service.dart';
import 'package:pomodoro_flutter/utils/consts/constant.dart';

@pragma('vm:entry-point')
class TaskHandler {
  @pragma('vm:entry-point')
  static Future<bool> executeTask(String task, Map<String, dynamic>? inputData) async {
    try {
      final notificationService = NotificationService();
      await notificationService.init();
      final processingService = ProcessingService();

      if (task == AppConstants.pomodoroTimerTask) {
        final processing = await processingService.loadProcessing();

        if (processing.isTimerRunning && processing.remainingTime > 0) {
          final nextState = processing.getNextProcessingState();
          final updatedProcessing = processing.copyWith(remainingTime: 0, isTimerRunning: false, state: nextState);

          await processingService.saveProcessing(updatedProcessing);

           await notificationService.showNotification('Pomodoro Timer', I10n().t.notification_stateChanged(nextState));
          VibrationService.vibrate(duration: 1000);
        }
      }
      return true;
    } catch (e) {
      print('Task execution error: $e'); // В продакшене заменить на логгер
      return false;
    }
  }
}
