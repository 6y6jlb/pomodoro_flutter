import 'dart:async';
import 'package:pomodoro_flutter/services/processing_service.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';

class ProcessingTimerService {
  int _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
  Timer? _mainTimer;
  final ProcessingService _processingService = ProcessingService();
  Function(int)? _onTick;

  int get remainingTime => _remainingTime;

  void startTimer(int durationInSeconds, Function(int) onTick, Function() onComplete) {
    _remainingTime = durationInSeconds;
    _onTick = onTick;
    _mainTimer?.cancel();
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        if (_remainingTime % 5 == 0 || _remainingTime == 0) {
          _processingService.saveRemainingTime(_remainingTime);
        }
        _onTick?.call(_remainingTime);
      } else {
        timer.cancel();
        _processingService.saveTimerState(false);
        onComplete();
      }
    });
    _processingService.saveTimerState(true);
  }

  void stopTimer() {
    _mainTimer?.cancel();
    _remainingTime = 0;
    _processingService.saveRemainingTime(_remainingTime);
    _processingService.saveTimerState(false);
  }

  Future<void> loadState() async {
    _remainingTime = await _processingService.loadRemainingTime();
  }

  void dispose() {
    _mainTimer?.cancel();
  }
}
