import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/pomodoro_settings.dart';
import 'package:pomodoro_flutter/models/processing.dart';
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
    _processing = _processing.makeActive();
    notifyListeners();
  }

  void makeInactive() {
    _processing = _processing.makeInactive();
    notifyListeners();
  }

  void makeRest() {
    _processing = _processing.makeRest();
    notifyListeners();
  }

  void makeRestDelay() {
    _processing = _processing.makeRestDelay();
    notifyListeners();
  }

  void getNextProcessType() {
    // check current pomodoro use type
    // -
    // if schedule based -> check it active or not
    // if schefule active -> get next proccessing type based on current type and next break type(long, short, delay)
    // if schedult inactive -> make inactive
    // -
    // if standart -> get next proccessing type based on current type(active->break->active(delay conditionally))
  }
}
