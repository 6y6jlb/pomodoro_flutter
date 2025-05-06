import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/utils/consts/settings_constant.dart';

class ProcessingProvider with ChangeNotifier {
  Processing _processing = Processing(state: ProcessingState.inactivity);
  PomodoroSettings? settings;

  int _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
  Timer? _lazyConfirmationTimer;

  ProcessingProvider([PomodoroSettings? settings]) {
    if (settings != null) {
      updateSettings(settings);
    } else {
      _processing = Processing(state: ProcessingState.inactivity);
    }

    _processing = Processing(
      settings: settings,
      state: ProcessingState.inactivity,
    );
  }

  Processing get processing => _processing;

  void changeState(ProcessingState state, {bool interactiveDelay = false}) {
    _processing = _processing.copyWithNewState(state);
    GlobalNotificationStream.addNotification(
      NotificationFactory.createStateUpdateEvent(
        message: _processing.state.label(),
        withSound: !interactiveDelay,
      ),
    );
    notifyListeners();
  }

  void makeActive({bool background = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.activity);
    GlobalNotificationStream.addNotification(
      NotificationFactory.createStateUpdateEvent(
        message: _processing.state.label(),
        withSound: background,
      ),
    );
    notifyListeners();
  }

  void makeInactive({bool background = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    GlobalNotificationStream.addNotification(
      NotificationFactory.createStateUpdateEvent(
        message: _processing.state.label(),
        withSound: background,
      ),
    );
    notifyListeners();
  }

  void makeRest({bool background = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.rest);
    GlobalNotificationStream.addNotification(
      NotificationFactory.createStateUpdateEvent(
        message: _processing.state.label(),
        withSound: background,
      ),
    );
    notifyListeners();
  }

  void makeRestDelay({bool background = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.restDelay);
    GlobalNotificationStream.addNotification(
      NotificationFactory.createStateUpdateEvent(
        message: _processing.state.label(),
        withSound: background,
      ),
    );
    notifyListeners();
  }

  void updateSettings(PomodoroSettings newSettings) {
    settings = newSettings;
    _processing = Processing(
      settings: settings!,
      state: ProcessingState.inactivity,
    );
    notifyListeners();
  }

  void makeNextPeriod({bool background = true}) {
    _processing = _processing.copyWithNewState(
      _processing.getNextProcessingState(),
    );
    GlobalNotificationStream.addNotification(
      NotificationFactory.createDefaultEvent(
        message: _processing.state.label(),
        withSound: background,
      ),
    );
    notifyListeners();
  }

    void _startLazyConfirmation(VoidCallback confirmationCallback, VoidCallback cancelCallback) {
    _remainingTime = 5;
    _lazyConfirmationTimer?.cancel(); // Отменяем предыдущий таймер, если он существует

    _lazyConfirmationTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      _remainingTime--;

      if (_remainingTime <= 0) {
        timer.cancel();
        confirmationCallback();
      }
    });
  }
}
