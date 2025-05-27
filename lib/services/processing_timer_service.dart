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
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingTime > 0) {
        _remainingTime--;
        if (_remainingTime % 5 == 0 || _remainingTime == 0) {
          final processing = await _processingService.loadProcessing();
          await _processingService.saveProcessing(
            processing.copyWith(remainingTime: _remainingTime, isTimerRunning: true),
          );
        }
        _onTick?.call(_remainingTime);
      } else {
        timer.cancel();
        final processing = await _processingService.loadProcessing();
        await _processingService.saveProcessing(processing.copyWith(remainingTime: 0, isTimerRunning: false));
        onComplete();
      }
    });
  }

  void stopTimer() {
    _mainTimer?.cancel();
    _remainingTime = 0;
  }

  Future<void> loadState() async {
    final processing = await _processingService.loadProcessing();
    _remainingTime = processing.remainingTime;
  }

  void dispose() {
    _mainTimer?.cancel();
  }
}
