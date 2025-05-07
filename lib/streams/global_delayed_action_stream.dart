import 'dart:async';

import 'package:pomodoro_flutter/events/delayed_action_event.dart';

class GlobaDelayedActionStream {
  static final StreamController<DelayedActionEvent> _streamController =
      StreamController.broadcast();

  static Stream<DelayedActionEvent> get stream => _streamController.stream;

  static void add(DelayedActionEvent event) {
    _streamController.add(event);
  }

  static void dispose() {
    _streamController.close();
  }
}
