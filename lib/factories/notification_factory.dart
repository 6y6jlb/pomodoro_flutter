import 'package:pomodoro_flutter/events/notification_events.dart';

class NotificationFactory {

static NotificationEvent createDefaultEvent(String message) {
    return NotificationEvent(
      type: 'default_event',
      message: message,
      soundKey: 'default',
    );
  }

  static NotificationEvent createModeChangeEvent(String newMode) {
    return NotificationEvent(
      type: 'mode_change',
      message: 'Mode switched to $newMode',
      soundKey: 'request',
    );
  }

  static NotificationEvent createStatusUpdateEvent(String status) {
    return NotificationEvent(
      type: 'status_update',
      message: 'Status updated: $status',
      soundKey: 'toggle',
    );
  }

  static NotificationEvent createExceptionAddedEvent(DateTime date) {
    return NotificationEvent(
      type: 'exception_added',
      message: 'Added exception for ${date.toIso8601String()}',
      soundKey: 'default',
    );
  }
}
