import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';

class ProcessingProvider with ChangeNotifier {
  Processing _processing = Processing(state: ProcessingState.inactivity);
  late PomodoroSettings settings;

  ProcessingProvider(settings) {
    _processing = Processing(
      settings: settings,
      state: ProcessingState.inactivity,
    );
  }

  Processing get processing => _processing;

  void makeActive() {
    _processing = _processing.copyWithNewState(ProcessingState.activity);
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeInactive() {
    _processing = _processing.copyWithNewState(ProcessingState.inactivity);
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeRest() {
    _processing = _processing.copyWithNewState(ProcessingState.rest);
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeRestDelay() {
    _processing = _processing.copyWithNewState(ProcessingState.restDelay);
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void updateSettings(PomodoroSettings settings) {
    _processing = _processing.copyWithNewSettings(settings);
    notifyListeners();
  }

  void makeNextPeriod() {
    _processing = _processing.copyWithNewState(
      _processing.getNextProcessingState(),
    );
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }
}
