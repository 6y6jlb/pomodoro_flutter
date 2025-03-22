import 'dart:async';

class GlobalNotificationStream {
  static final StreamController<String> _streamController = StreamController.broadcast();


  static Stream<String> get stream => _streamController.stream;

  static void addNotification(String message) {
    _streamController.add(message);
  }

  static void dispose() {
    _streamController.close();
  }
}