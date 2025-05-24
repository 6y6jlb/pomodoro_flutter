import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/services/notification_service.dart';
import 'package:pomodoro_flutter/services/sound_service.dart';
import 'package:pomodoro_flutter/services/vibration_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final SoundService _soundService = SoundService();

  NotificationProvider() {
    _initServices();
    _listenToEventBus();
  }

  Future<void> _initServices() async {
    await _notificationService.init();
  }

  void _listenToEventBus() {
    eventBus.onTyped<NotificationEvent>().listen((NotificationEvent event) {
      _handleNotificationEvent(event);
    });
  }

  void _handleNotificationEvent(NotificationEvent event) {
    if (event.soundKey != null) {
      print('Playing sound: ${event.soundKey}');
      _soundService.playSound(event.soundKey!);
    }

    if (event.message != null) {
      print('Showing notification: ${event.message}');
      _notificationService.showNotification('Pomodoro Timer', event.message!);
    }

    VibrationService.vibrate(duration: 500);
  }
}
