import 'package:pomodoro_flutter/events/notification_events.dart';
import 'package:pomodoro_flutter/services/i_10n.dart';

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
      message: I10n().t.notification_stateChanged(message),
      soundKey: withSound ? 'request' : null,
    );
  }

  static NotificationEvent createExceptionAddedEvent({
    DateTime? date,
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'exception_added',
      message: I10n().t.notification_exceptionAdded((date ?? DateTime.now()).toIso8601String()),
      soundKey: withSound ? 'default' : null,
    );
  }

   static NotificationEvent creatSoundEvent({
    String soundKey = 'request' ,
  }) {
    return NotificationEvent(
      type: 'sound',
      soundKey: soundKey,
    );
  }

  static NotificationEvent createBackgroundEvent({
    required String message,
    bool withSound = false,
  }) {
    return NotificationEvent(
      type: 'background',
      message: message,
      soundKey: withSound ? 'default' : null,
    );
  }
}
