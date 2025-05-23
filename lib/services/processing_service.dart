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

  Future<void> saveRemainingTime(int remainingTime) async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    await box.put(AppConstants.remainingTimeKey, remainingTime);
  }

  Future<int> loadRemainingTime() async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    return box.get(AppConstants.remainingTimeKey, defaultValue: SettingsConstant.defaultRemaingDurationInSeconds);
  }

  Future<void> saveTimerState(bool isRunning) async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    await box.put(AppConstants.isTimerRunningKey, isRunning);
  }

  Future<bool> loadTimerState() async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    return box.get(AppConstants.isTimerRunningKey, defaultValue: false);
  }

  Future<void> saveProcessingState(String state) async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    await box.put(AppConstants.processingStateKey, state);
  }

  Future<String> loadProcessingState() async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    return box.get(AppConstants.processingStateKey, defaultValue: 'inactivity');
  }

  Future<void> saveNextProcessingState(String nextState) async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    await box.put(AppConstants.nextProcessingStateKey, nextState);
  }

  Future<String> loadNextProcessingState() async {
    final box = await HiveService.openBox(AppConstants.timerStateBox);
    return box.get(AppConstants.nextProcessingStateKey, defaultValue: 'inactivity');
  }
}
