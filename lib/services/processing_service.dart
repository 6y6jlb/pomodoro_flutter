import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/services/hive_service.dart';
import 'package:pomodoro_flutter/utils/consts/constant.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import 'package:workmanager/workmanager.dart';

class ProcessingService {
  Future<void> scheduleTimerTask(int durationInSeconds) async {
    print('Scheduling timer task for $durationInSeconds seconds');
    await Workmanager().registerOneOffTask(
      AppConstants.pomodoroTimerTask,
      AppConstants.pomodoroTimerTask,
      initialDelay: Duration(seconds: durationInSeconds),
      constraints: Constraints(networkType: NetworkType.not_required),
    );
  }

  Future<void> cancelTimerTask() async {
    await Workmanager().cancelAll();
  }

  Future<void> saveProcessing(Processing processing) async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    await box.put(AppConstants.processingKey, processing);
  }

  Future<Processing> loadProcessing() async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    return box.get(
      AppConstants.processingKey,
      defaultValue: Processing(
        state: ProcessingState.inactivity,
        remainingTime: SettingsConstant.defaultRemaingDurationInSeconds,
        isTimerRunning: false,
      ),
    );
  }
}
