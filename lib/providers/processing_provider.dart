import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/factories/notification_factory.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';
import 'package:pomodoro_flutter/enums/processing_state.dart';

class ProcessingProvider with ChangeNotifier {
  Processing _processing = Processing(state: ProcessingState.inactivity);
  PomodoroSettings? settings;

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

  void makeActive({bool withSound = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.activity);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(message: _processing.state.label(), withSound: withSound));
    notifyListeners();
  }

  void makeInactive({bool withSound = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(message: _processing.state.label(), withSound: withSound));
    notifyListeners();
  }

  void makeRest({bool withSound = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.rest);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(message: _processing.state.label(), withSound: withSound));
    notifyListeners();
  }

  void makeRestDelay({bool withSound = false}) {
    _processing = _processing.copyWithNewState(ProcessingState.restDelay);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(message: _processing.state.label(), withSound: withSound));
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

  void makeNextPeriod({bool withSound = false}) {
    _processing = _processing.copyWithNewState(
      _processing.getNextProcessingState(),
    );
    GlobalNotificationStream.addNotification(NotificationFactory.createDefaultEvent(message: _processing.state.label(), withSound: withSound));
    notifyListeners();
  }
}
