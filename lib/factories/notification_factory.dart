import 'package:pomodoro_flutter/events/notification_events.dart';

class NotificationFactory {
  static NotificationEvent createDefaultEvent({
    String message = '',
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'default_event',
      message: message,
      soundKey: withSound ? 'default' : null,
    );
  }

  static NotificationEvent createModeChangeEvent({
    String message = '',
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'mode_change',
      message: 'Mode switched to $message',
      soundKey: withSound ? 'request' : null,
    );
  }

  static NotificationEvent createStateUpdateEvent({
    String message = '',
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'status_update',
      message: 'Status updated: $message',
      soundKey: withSound ? 'request' : null,
    );
  }

  static NotificationEvent createExceptionAddedEvent({
    DateTime? date,
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'exception_added',
      message:
          'Added exception for ${(date ?? DateTime.now()).toIso8601String()}',
      soundKey: withSound ? 'default' : null,
    );
  }
}
