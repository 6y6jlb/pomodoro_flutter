import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/delayed_action_event.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/event_bus/typed_event_bus.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';
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
    void handlerCb(bool withSound) {
      _processing = _processing.copyWithNewState(state);
      eventBus.emit(
        NotificationFactory.createStateUpdateEvent(
          message: _processing.state.label(),
          withSound: withSound,
        ),
      );
      notifyListeners();
    }

    if (interactiveDelay) {
      eventBus.emit(NotificationFactory.creatSoundEvent());
      _delayedHandler(handlerCb, (withSound) {
        _processing = _processing.copyWithNewState(state);
        eventBus.emit(
          NotificationFactory.createStateUpdateEvent(
            message: ProcessingState.restDelay.label(),
            withSound: withSound,
          ),
        );
        notifyListeners();
      }, I10n().t.delayedRestLabel);
    } else {
      handlerCb(false);
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
    _lazyConfirmationTimer
        ?.cancel(); // Отменяем предыдущий таймер, если он существует
    _lazyConfirmationTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      _remainingTime--;

      if (_remainingTime <= 0) {
        timer.cancel();
        confirmationCallback(true);
      }
    });
  }
}
