import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:pomodoro_flutter/streams/global_notification_stream.dart';

class NotificationProvider with ChangeNotifier{
  final Queue<String> _notifications = Queue();
  late StreamSubscription<String> _notificationSubscription;


  NotificationProvider() {
    _notificationSubscription = GlobalNotificationStream.stream.listen((message) {
      addNotification(message);
    });
  }

  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
  }

  void removeNotification() {
    if(_notifications.isNotEmpty) {
      _notifications.removeFirst();
    }
  }

  String? get nextNotification => _notifications.firstOrNull;

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }
}