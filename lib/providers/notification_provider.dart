import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/sound_service.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final SoundService _soundService = SoundService();

  NotificationProvider() {
    print('init povider');
    _initServices();
    _listenToGlobalStream();
  }

  Future<void> _initServices() async {
    await _notificationService.init();
  }

  void _listenToGlobalStream() {
    print('Subscribing to GlobalNotificationStream...');
    GlobalNotificationStream.stream.listen((NotificationEvent event) {
      print('Received event: ${event.type}, message: ${event.message}');
      _handleNotificationEvent(event);
    });
  }

  void _handleNotificationEvent(NotificationEvent event) {
    if (event.soundKey != null) {
      _soundService.playSound(event.soundKey!);
    }

    _notificationService.showNotification(event.type, event.message);
  }
}
