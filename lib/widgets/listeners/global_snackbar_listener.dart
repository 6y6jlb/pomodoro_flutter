import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/event_bus/event_bus_provider.dart';
import 'package:pomodoro_flutter/event_bus/typed_event_bus.dart';

class GlobalSnackbarListener extends StatefulWidget {
  final Widget child;

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  State<GlobalSnackbarListener> createState() => _GlobalSnackbarListenerState();
}

class _GlobalSnackbarListenerState extends State<GlobalSnackbarListener> {
  late StreamSubscription<NotificationEvent> _notificationSubscription;

  void _listenForNotificationEvent() {
    _notificationSubscription = eventBus.onTyped<NotificationEvent>().listen((
      event,
    ) {
      if (event.message != null) {
        _showSnackbar(event.message!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenForNotificationEvent();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
