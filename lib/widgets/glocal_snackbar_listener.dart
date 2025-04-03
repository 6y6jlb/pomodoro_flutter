import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class GlobalSnackbarListener extends StatefulWidget {
  final Widget child;

  const GlobalSnackbarListener({super.key, required this.child});

  @override
  State<GlobalSnackbarListener> createState() => _GlobalSnackbarListenerState();
}

class _GlobalSnackbarListenerState extends State<GlobalSnackbarListener> {
  void _showNextSnackbar(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final nextNotification = notificationProvider.nextNotification;

    if (nextNotification != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nextNotification),
          duration: const Duration(seconds: 1),
        ),
      ).closed.then((_) {
        notificationProvider.removeNotification();
        _showNextSnackbar(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (notificationProvider.nextNotification != null) {
            _showNextSnackbar(context);
          }
        });
        return widget.child;
      },
    );
  }
}