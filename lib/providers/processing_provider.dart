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

  void makeActive() {
    _processing = _processing.copyWithNewState(ProcessingState.activity);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(_processing.state.label()));
    notifyListeners();
  }

  void makeInactive() {
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(_processing.state.label()));
    notifyListeners();
  }

  void makeRest() {
    _processing = _processing.copyWithNewState(ProcessingState.rest);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(_processing.state.label()));
    notifyListeners();
  }

  void makeRestDelay() {
    _processing = _processing.copyWithNewState(ProcessingState.restDelay);
    GlobalNotificationStream.addNotification(NotificationFactory.createStatusUpdateEvent(_processing.state.label()));
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

  void makeNextPeriod() {
    _processing = _processing.copyWithNewState(
      _processing.getNextProcessingState(),
    );
    GlobalNotificationStream.addNotification(NotificationFactory.createDefaultEvent(_processing.state.label()));
    notifyListeners();
  }
}
