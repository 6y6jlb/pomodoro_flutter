import 'dart:async';

import 'package:pomodoro_flutter/events/notification_events.dart';

class GlobalNotificationStream {
  static final StreamController<NotificationEvent> _streamController =
      StreamController.broadcast();

  static Stream<NotificationEvent> get stream => _streamController.stream;

  static void add(NotificationEvent event) {
    _streamController.add(event);
  }

  static void dispose() {
    _streamController.close();
  }
}
