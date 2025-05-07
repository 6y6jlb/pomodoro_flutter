import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/streams/global_delayed_action_stream.dart';
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
    handlerCb() {
      _processing = _processing.copyWithNewState(state);
      GlobalNotificationStream.add(
        NotificationFactory.createStateUpdateEvent(
          message: _processing.state.label(),
          withSound: !interactiveDelay,
        ),
      );
      notifyListeners();
    }

    if (interactiveDelay) {
      //TODO: change to dynamic delayed state
      _delayedHandler(handlerCb, () {
        _processing = _processing.copyWithNewState(state);
        GlobalNotificationStream.add(
          NotificationFactory.createStateUpdateEvent(
            message: ProcessingState.restDelay.label(),
            withSound: true,
          ),
        );
        notifyListeners();
      }, 'Пора сделать перерыв!');
    } else {
      handlerCb();
    }
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
    final nextState = _processing.getNextProcessingState();
    changeState(nextState, interactiveDelay: true);
  }

  void _delayedHandler(
    VoidCallback confirmationCallback,
    VoidCallback cancellationCallback,
    String message,
  ) {
    GlobaDelayedActionStream.add(
      DelayedActionEvent(
        type: 'state_change',
        message: message,
        confirmationAction: confirmationCallback,
        cancellationAction: cancellationCallback,
      ),
    );
    _remainingTime = SettingsConstant.defaultRemaingDurationInSeconds;
    _lazyConfirmationTimer
        ?.cancel(); // Отменяем предыдущий таймер, если он существует
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
