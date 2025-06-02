import 'dart:async';
import 'dart:math';

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
  Timer? _interactiveDelayTimer;
  final ProcessingService _processingService = ProcessingService();
  final ProcessingTimerService _processingTimerService = ProcessingTimerService();

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

  void changeState(ProcessingState state, {bool shouldDelay = false}) {
    print('changeState: state - ${state.label()}, interactiveDelay - $shouldDelay');
    void handlerCb(bool withSound) {
      _processing = _processing.copyWith(
        state: state,
        remainingTime: _processing.periodDurationInSeconds,
        isTimerRunning: true,
      );
      _saveState();

      var nextState = _processing.getNextProcessingState();
      print('nextState: ${nextState.label()}');
      print('app is active: $_isAppActive');

      if (_isAppActive) {
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(
            message: _processing.state.label(),
            withSound: _isAppActive && withSound,
          ),
        );
        _processingTimerService.startTimer(
          _processing.remainingTime,
          (time) => updateRemainingTime(time),
          state.isInactive() ? () {} : () => changeState(nextState, shouldDelay: nextState.isRest()),
        );
      } else {
        _processingService.scheduleTimerTask(_processing.remainingTime);
      }

      notifyListeners();
    }

    if (_isAppActive) {
      if (shouldDelay) {
        print('shouldDelay, starting lazy confirmation');
        _delayedHandler(handlerCb, (withSound) {
          _processing = _processing.copyWith(state: state);
          _saveState();
          eventBus.emit(NotificationFactory.createStateUpdateEvent(message: state.label(), withSound: withSound));
          notifyListeners();
        }, I10n().t.delayedRestLabel);
      } else {
        print('Immediate state change without delay');
        handlerCb(false);
      }
      notifyListeners();
    } else {
      print('App is not active, skipping state change');
      handlerCb(false);
    }
  }

  void resetTimer() {
    print('resetTimer');
    _interactiveDelayTimer?.cancel();
    _processingTimerService.stopTimer();
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
    _processingTimerService.stopTimer();
    _interactiveDelayTimer?.cancel();
    _interactiveDelayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    await _processingTimerService.loadState();
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
      _processingTimerService.startTimer(
        _processing.remainingTime,
        (time) => updateRemainingTime(time),
        () => changeState(
          _processing.getNextProcessingState(),
          shouldDelay: _processing.getNextProcessingState().isRest(),
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
    _interactiveDelayTimer?.cancel();
    _processingTimerService.dispose();
    super.dispose();
  }
}
