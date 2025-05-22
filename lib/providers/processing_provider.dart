import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/services/processing_service.dart';
import 'package:pomodoro_flutter/services/processing_timer_service.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';
import '../models/pomodoro_settings.dart';

class ProcessingProvider with ChangeNotifier, WidgetsBindingObserver {
  Processing _processing = Processing(state: ProcessingState.inactivity);
  PomodoroSettings? settings;
  int _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
  bool _isAppActive = true;
  Timer? _lazyConfirmationTimer;
  final ProcessingService _processingService = ProcessingService();
  final ProcessingTimerService _timerService = ProcessingTimerService();

  ProcessingProvider([PomodoroSettings? settings]) {
    WidgetsBinding.instance.addObserver(this);
    if (settings != null) {
      updateSettings(settings);
    } else {
      _processing = Processing(state: ProcessingState.inactivity);
    }
    _loadState();
  }

  Processing get processing => _processing;
  int get remainingTime => _remainingTime;
  bool get isAppActive => _isAppActive;

  void updateSettings(PomodoroSettings newSettings) {
    settings = newSettings;
    _processing = Processing(settings: settings!, state: ProcessingState.inactivity);
    _remainingTime = newSettings.currentSessionDurationInSeconds;
    _saveState();
    notifyListeners();
  }

  void updateRemainingTime(int newRemainingTime) {
    _remainingTime = newRemainingTime;
    notifyListeners();
  }

  void changeState(ProcessingState state, {bool interactiveDelay = false}) {
    print('changeState: ${state.label()}');
    void handlerCb(bool withSound) {
      _processing = _processing.copyWithNewState(state);
      _remainingTime = _processing.periodDurationInSeconds;
      _saveState();

      if (!_isAppActive) {
        print("App is not active");
        _processingService.scheduleTimerTask(_remainingTime);
      } else {
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(message: _processing.state.label(), withSound: withSound),
        );
      }

      _timerService.startTimer(
        _remainingTime,
        (time) => updateRemainingTime(time),
        () => changeState(_processing.getNextProcessingState(), interactiveDelay: true),
      );
      notifyListeners();
    }

    if (interactiveDelay) {
      eventBus.emit(NotificationFactory.creatSoundEvent());
      _delayedHandler(handlerCb, (withSound) {
        _processing = _processing.copyWithNewState(state);
        _saveState();
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
    changeState(_processing.getNextProcessingState(), interactiveDelay: true);
  }

  void resetTimer() {
    print('resetTimer');
    _lazyConfirmationTimer?.cancel();
    _timerService.stopTimer();
    _remainingTime = 0;
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    _saveState();
    _processingService.cancelTimerTask();
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
    _timerService.stopTimer();
    _lazyConfirmationTimer?.cancel();
    _lazyConfirmationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingTime--;

      if (_remainingTime <= 0) {
        timer.cancel();
        confirmationCallback(true);
      }

      _saveState();
      notifyListeners();
    });
  }

  Future<void> _loadState() async {
    await _timerService.loadState();
    _remainingTime = _timerService.remainingTime;
    final savedState = await _processingService.loadProcessingState();
    final savedNextState = await _processingService.loadNextProcessingState();
    final isRunning = await _processingService.loadTimerState();

    _processing = _processing.copyWithNewState(
      ProcessingState.values.firstWhere(
        (state) => state.label() == savedState,
        orElse: () => ProcessingState.inactivity,
      ),
    );

    print(
      '_loadState: remainingTime: $_remainingTime, state: ${_processing.state.label()}, nextState: $savedNextState',
    );

    if (isRunning && _remainingTime > 0 && _processing.state != ProcessingState.inactivity) {
      _timerService.startTimer(
        _remainingTime,
        (time) => updateRemainingTime(time),
        () => changeState(_processing.getNextProcessingState(), interactiveDelay: true),
      );
    }

    notifyListeners();
  }

  Future<void> _saveState() async {
    await _processingService.saveRemainingTime(_remainingTime);
    await _processingService.saveProcessingState(_processing.state.label());
    await _processingService.saveNextProcessingState(_processing.getNextProcessingState().label());
    await _processingService.saveTimerState(_remainingTime > 0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed: $state');
    _isAppActive = state == AppLifecycleState.resumed;

    if (!_isAppActive) {
      _saveState();
      if (_remainingTime > 0) {
        _processingService.scheduleTimerTask(_remainingTime);
      }
    } else {
      _loadState();
      _processingService.cancelTimerTask();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lazyConfirmationTimer?.cancel();
    _timerService.dispose();
    super.dispose();
  }
}
