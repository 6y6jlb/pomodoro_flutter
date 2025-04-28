import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class GlobalSnackbarListener extends StatefulWidget {
  final Widget child;

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  State<GlobalSnackbarListener> createState() => _GlobalSnackbarListenerState();
}

class _GlobalSnackbarListenerState extends State<GlobalSnackbarListener> {
  late StreamSubscription<NotificationEvent> _notificationSubscription;

  @override
   void initState() {
    super.initState();
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );
    _notificationSubscription = notificationProvider.eventStream.listen((
      NotificationEvent event,
    ) {
      _showSnackbar(event.message);
    });
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
