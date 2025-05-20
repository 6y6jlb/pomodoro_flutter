import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import '../models/pomodoro_settings.dart';
import '../services/timer_service.dart';

class ProcessingProvider with ChangeNotifier, WidgetsBindingObserver {
  Processing _processing = Processing(state: ProcessingState.inactivity);
  PomodoroSettings? settings;
  int _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
  bool _isAppActive = true;
  Timer? _lazyConfirmationTimer;
  final TimerService _timerService = TimerService();

  ProcessingProvider([PomodoroSettings? settings]) {
    WidgetsBinding.instance.addObserver(this);
    if (settings != null) {
      updateSettings(settings);
    } else {
      _processing = Processing(state: ProcessingState.inactivity);
    }
    _loadRemainingTime();
  }

  Processing get processing => _processing;
  int get remainingTime => _remainingTime;
  bool get isAppActive => _isAppActive;

  void updateSettings(PomodoroSettings newSettings) {
    settings = newSettings;
    _processing = Processing(settings: settings!, state: ProcessingState.inactivity);
    notifyListeners();
  }

  void changeState(ProcessingState state, {bool interactiveDelay = false}) {
    void handlerCb(bool withSound) {
      _processing = _processing.copyWithNewState(state);

      if (!_isAppActive) {
        eventBus.emit(
          NotificationFactory.createBackgroundEvent(message: _processing.state.label(), withSound: withSound),
        );
      } else {
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(message: _processing.state.label(), withSound: withSound),
        );
      }

      notifyListeners();
    }

    if (interactiveDelay) {
      eventBus.emit(NotificationFactory.creatSoundEvent());
      _delayedHandler(handlerCb, (withSound) {
        _processing = _processing.copyWithNewState(state);
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(message: ProcessingState.restDelay.label(), withSound: withSound),
        );
        notifyListeners();
      }, I10n().t.delayedRestLabel);
    } else {
      handlerCb(false);
    }
  }

  void makeNextPeriod({bool background = true}) {
    final nextState = _processing.getNextProcessingState();
    changeState(nextState, interactiveDelay: true);

    // Планируем задачу Workmanager
    _timerService.scheduleTimerTask(_processing.periodDurationInSeconds);
  }

  void resetTimer() {
    _lazyConfirmationTimer?.cancel();
    _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
    _timerService.cancelTimerTask();
    _timerService.saveRemainingTime(_remainingTime);
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    notifyListeners();
  }

  void _delayedHandler(
    void Function(bool withSound) confirmationCallback,
    void Function(bool withSound) cancellationCallback,
    String message,
  ) {
    eventBus.emit(
      DelayedActionEvent(
        type: 'state_change',
        message: message,
        confirmationAction: () => confirmationCallback(false),
        cancellationAction: () => cancellationCallback(false),
      ),
    );
    eventBus.emit(NotificationFactory.creatSoundEvent());
    _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
    _lazyConfirmationTimer?.cancel();
    _lazyConfirmationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingTime--;

      if (_remainingTime <= 0) {
        timer.cancel();
        confirmationCallback(true);
      }

      _timerService.saveRemainingTime(_remainingTime);
    });
  }

  Future<void> _loadRemainingTime() async {
    _remainingTime = await _timerService.loadRemainingTime();
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed: $state');
    _isAppActive = state == AppLifecycleState.resumed;

    if (!_isAppActive) {
      _timerService.saveRemainingTime(_remainingTime);
    } else {
      _loadRemainingTime();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lazyConfirmationTimer?.cancel();
    super.dispose();
  }
}
