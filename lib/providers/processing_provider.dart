import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/models/processing.dart';
import 'package:pomodoro_flutter/utils/enums/processing_state.dart';

class ProcessingProvider with ChangeNotifier {
  Processing _processing = Processing(state: ProcessingState.inactivity);

  Processing get processing => _processing;

  void makeActive() {
    _processing = _processing.makeActive();
    notifyListeners();
  }

  void makeInactive() {
    _processing = _processing.makeInactive();
    notifyListeners();
  }

  void makeBriefRest() {
    _processing = _processing.makeBriefRest();
    notifyListeners();
  }

  void makeLongfRest() {
    _processing = _processing.makeLongfRest();
    notifyListeners();
  }

  void makeRestDelay() {
    _processing = _processing.makeRestDelay();
    notifyListeners();
  }
}
