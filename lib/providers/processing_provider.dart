import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
import 'package:pomodoro_flutter/services/processing_service.dart';
import 'package:pomodoro_flutter/services/processing_timer_service.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';

class ProcessingProvider with ChangeNotifier, WidgetsBindingObserver {
  Processing _processing = Processing(
    state: ProcessingState.inactivity,
    remainingTime: SettingsConstant.defaultRemaingDurationInSeconds,
    isTimerRunning: false,
  );
  bool _isAppActive = true;
  Timer? _lazyConfirmationTimer;
  final ProcessingService _processingService = ProcessingService();
  final ProcessingTimerService _timerService = ProcessingTimerService();

  ProcessingProvider([PomodoroSettings? settings]) {
    WidgetsBinding.instance.addObserver(this);
    if (settings != null) {
      updateSettings(settings);
    }
    _loadState();
  }

  Processing get processing => _processing;
  PomodoroSettings? get settings => _processing.settings;
  int get remainingTime => _processing.remainingTime;
  bool get isAppActive => _isAppActive;

  void updateSettings(PomodoroSettings newSettings) {
    _processing = _processing.copyWithNewSettings(newSettings);
    _processing = _processing.copyWith(
      state: ProcessingState.inactivity,
      remainingTime: newSettings.currentSessionDurationInSeconds,
      isTimerRunning: false,
    );
    _saveState();
    notifyListeners();
  }

  void updateRemainingTime(int newRemainingTime) {
    _processing = _processing.copyWith(remainingTime: newRemainingTime);
    notifyListeners();
  }

  void changeState(ProcessingState state, {bool interactiveDelay = false}) {
    print('changeState: state - ${state.label()}, interactiveDelay - $interactiveDelay');
    void handlerCb(bool withSound) {
      _processing = _processing.copyWith(
        state: state,
        remainingTime: _processing.periodDurationInSeconds,
        isTimerRunning: true,
      );
      _saveState();

      eventBus.emit(
        NotificationFactory.createStateUpdateEvent(
          message: _processing.state.label(),
          withSound: _isAppActive && withSound,
        ),
      );

      if (!_isAppActive) {
        print("changeState: app is not active");
        _processingService.scheduleTimerTask(_processing.remainingTime);
      }

      var nextState = _processing.getNextProcessingState();

      print('changeState: startTimer: ${_processing.remainingTime}, nextState: ${nextState.label()}');
      if (_isAppActive) {
        _timerService.startTimer(
          _processing.remainingTime,
          (time) => updateRemainingTime(time),
          state.isInactive() ? () {} : () => changeState(nextState, interactiveDelay: nextState.isRest()),
        );
      }
      notifyListeners();
    }

    if (_isAppActive && interactiveDelay && state.isRest()) {
      print('Starting lazy confirmation for rest state');
      _delayedHandler(handlerCb, (withSound) {
        _processing = _processing.copyWith(state: state);
        _saveState();
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(
            message: ProcessingState.restDelay.label(),
            withSound: _isAppActive && withSound,
          ),
        );
        notifyListeners();
      }, I10n().t.delayedRestLabel);
    } else {
      handlerCb(false);
    }
  }

  void resetTimer() {
    print('resetTimer');
    _lazyConfirmationTimer?.cancel();
    _timerService.stopTimer();
    _processing = _processing.copyWith(state: ProcessingState.inactivity, remainingTime: 0, isTimerRunning: false);
    _saveState();
    _processingService.cancelTimerTask();
    notifyListeners();
  }

  void _delayedHandler(
    void Function(bool withSound) confirmationCallback,
    void Function(bool withSound) cancellationCallback,
    String message,
  ) {
    print('_delayedHandler: $message');
    eventBus.emit(
      DelayedActionEvent(
        type: 'state_change',
        message: message,
        confirmationAction: () => confirmationCallback(true),
        cancellationAction: () => cancellationCallback(true),
      ),
    );
    _processing = _processing.copyWith(
      remainingTime: SettingsConstant.defaultRemaingDurationInSeconds,
      isTimerRunning: false,
    );
    _timerService.stopTimer();
    _lazyConfirmationTimer?.cancel();
    _lazyConfirmationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _processing = _processing.copyWith(remainingTime: _processing.remainingTime - 1);

      if (_processing.remainingTime <= 0) {
        timer.cancel();
        confirmationCallback(true);
      }

      _saveState();
      notifyListeners();
    });
  }

  Future<void> _loadState() async {
    await _timerService.loadState();
    _processing = await _processingService.loadProcessing();

    print(
      '_loadState: remainingTime: ${_processing.remainingTime}, '
      'state: ${_processing.state.label()}, '
      'isTimerRunning: ${_processing.isTimerRunning}',
    );

    if (_processing.isTimerRunning &&
        _processing.remainingTime > 0 &&
        _processing.state != ProcessingState.inactivity &&
        _isAppActive) {
      _timerService.startTimer(
        _processing.remainingTime,
        (time) => updateRemainingTime(time),
        () => changeState(
          _processing.getNextProcessingState(),
          interactiveDelay: _processing.getNextProcessingState().isRest(),
        ),
      );
    }

    notifyListeners();
  }

  Future<void> _saveState() async {
    await _processingService.saveProcessing(_processing);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState changed: $state');
    _isAppActive = state == AppLifecycleState.resumed;

    if (_isAppActive) {
      _loadState();
      _processingService.cancelTimerTask();
    } else {
      _saveState();
      if (_processing.remainingTime > 0 && _processing.isTimerRunning) {
        _processingService.scheduleTimerTask(_processing.remainingTime);
      }
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
