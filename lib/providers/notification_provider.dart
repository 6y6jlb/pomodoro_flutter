import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/sound_service.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final SoundService _soundService = SoundService();

   final StreamController<NotificationEvent> _eventController =
      StreamController.broadcast();
  Stream<NotificationEvent> get eventStream => _eventController.stream;

  NotificationProvider() {
    _initServices();
    _listenToGlobalStream();
  }

  Future<void> _initServices() async {
    await _notificationService.init();
  }

  void _listenToGlobalStream() {
    GlobalNotificationStream.stream.listen((NotificationEvent event) {
      _handleNotificationEvent(event);
      _eventController.add(event);
    });
  }

  void _handleNotificationEvent(NotificationEvent event) {
    if (event.soundKey != null) {
      _soundService.playSound(event.soundKey!);
    }

    if(event.type != 'sound' && event.message != null) {
      _notificationService.showNotification(event.type, event.message!);
    }
  }
}
