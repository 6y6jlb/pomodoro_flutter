import 'package:pomodoro_flutter/enums/processing_state.dart';
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
        final remainingTime = await processingService.loadRemainingTime();
        final isRunning = await processingService.loadTimerState();
        final nextState = await processingService.loadNextProcessingState();

        // Проверяем, активен ли таймер и не завершен ли он уже
        if (isRunning && remainingTime > 0) {
          await processingService.saveRemainingTime(0);
          await processingService.saveTimerState(false);
          await processingService.saveProcessingState(nextState);
          await processingService.saveNextProcessingState(ProcessingState.inactivity.label());

          await notificationService.showNotification(
            'Pomodoro Timer',
            'Таймер завершён! Переходим к состоянию: $nextState',
          );
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
