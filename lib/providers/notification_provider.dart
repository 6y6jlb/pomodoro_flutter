import 'dart:collection';

import 'package:flutter/widgets.dart';

class NotificationProvider with ChangeNotifier{
  final Queue<String> _notifications = Queue();

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
}