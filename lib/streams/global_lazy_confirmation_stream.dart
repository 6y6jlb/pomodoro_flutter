import 'dart:async';

import 'package:pomodoro_flutter/events/notification_events.dart';

class GlobalLazyConfirmationStream {
  static final StreamController<NotificationEvent> _streamController =
      StreamController.broadcast();

  static Stream<NotificationEvent> get stream => _streamController.stream;

  static void addLazyConfirmationEvent(event) {
    _streamController.add(event);
    // TODO
  }

  static void dispose() {
    _streamController.close();
  }
}
