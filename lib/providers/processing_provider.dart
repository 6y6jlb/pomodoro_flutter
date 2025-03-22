import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';

class ProcessingProvider with ChangeNotifier {
  
  Processing _processing = Processing(
    state: ProcessingState.inactivity,
    periodDurationInSeconds: 0,
  );
  late PomodoroSettings settings;

  ProcessingProvider(settings) {
    _processing = Processing(
      settings: settings,
      periodDurationInSeconds: 0,
      state: ProcessingState.inactivity,
    );
  }

  Processing get processing => _processing;

  void makeActive() {
    _processing = _processing.makeActive();
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeInactive() {
    _processing = _processing.makeInactive();
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeRest() {
    _processing = _processing.makeRest();
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }

  void makeRestDelay() {
    _processing = _processing.makeRestDelay();
    GlobalNotificationStream.addNotification(_processing.state.label());
    notifyListeners();
  }
}
